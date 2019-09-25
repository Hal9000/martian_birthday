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
          @earth_month_name = @birthday.strftime('%B')
          @m_date = @birthday.strftime('%d')
          @m_month_name = mrtn_dob.month_name
          @m_month = mrtn_dob.month
          @m_year = mrtn_dob.year
          @famous_people = get_famous_people(mrtn_dob.year, mrtn_dob.month, @birthday.strftime('%d'))
          @famous_people = @famous_people.sample
        rescue ArgumentError
          @error = 'The Given URL is invalid, please retry and find your martial Birthday'
        end
      else
        @error = 'The Given URL is invalid, please retry and find your martial Birthday'
      end
    end
    @birthday = Date.today if @birthday.nil?
    @image_location = "/uploads/" + @birthday.to_s.strip.split('-').join() + '.jpg'
    if file_exist(@image_location)
      save_martian_birthday_image(@birthday, @image_location)
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

  def get_famous_people(year, month, day)
    famous_people = []
    file = File.open(Rails.root.join('HAL','famous.txt'), 'r')
    file.each_line do |line|
      dataArray = line.split('|')
      if (dataArray[0].to_i.eql? month.to_i) && (dataArray[1].to_i.eql? day.to_i) && (dataArray[2].to_i.eql? year.to_i)
        famous_people << dataArray[6]
      end
    end
    file.close
    famous_people
  end
end

