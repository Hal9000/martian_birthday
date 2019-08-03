require 'mars_dist'
require 'orbit_image'
require 'orbit_data'
require 'url_parse'
require 'month'

class MartiandateController < ApplicationController

  def index
    url_string = request[:id]
    if url_string
      parse_data = UrlParse.new(url_string).parse()
      @name = parse_data[:name].strip.split('-').join(' ')
      if parse_data[:birthday].present?
        begin
          Date.parse(parse_data[:birthday])
          @birthday = Date.strptime(parse_data[:birthday], '%d-%B-%Y')
          mrtn_dob = MarsDateTime.new(@birthday)
          @earth_dob = @birthday.strftime('%B %d, %Y')
          @earth_year = @birthday.strftime('%Y')
          @month = @birthday.strftime('%d')
          @month_name = @birthday.strftime('%B')
          @mrtn_year = mrtn_dob.year
        rescue ArgumentError
          @error = 'The Given URL is invalid, please retry and find your martial Birthday'
        end
      else
        @error = 'The Given URL is invalid, please retry and find your martial Birthday'
      end
    end
    @birthday = Date.today if @birthday.nil?
    @image_name = "/uploads/" + @birthday.to_s.strip.split('-').join() + '.jpg'
    if file_exist(@image_name)
      save_martian_birthday_image(@birthday, @image_name)
    end
    if @earth_dob
      render :result
    end
  end

  def file_exist(file_name)
    !File.file? "#{Rails.root}/public#{file_name}"
  end

  def save_martian_birthday_image(date, image_name)
    image_path = "public#{image_name}"
    yyyy, mm, dd = date.to_s.strip.split('-')
    edeg, mdeg = OrbitalCalculations.new.get_earth_mars_angles(yyyy.to_i, mm.to_i, dd.to_i)
    EarthMarsOrbits.make_image(edeg.round(1), mdeg.round(1), image_path)
  end
end

