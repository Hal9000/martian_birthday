require 'rmagick'
require 'date'

include Magick

class EarthMarsOrbits

  Wide, High = 400, 400
  X0, Y0 = Wide/2, High/2

  def disk(angle, orbit_radius, radius, fill)
    orb = Draw.new
    orb.fill = fill
    orb.stroke("black")
    orb.stroke_width(1)
    rads = -(angle/360.0) * 2*Math::PI  # counterclockwise!
    y, x = Y0 + 2*orbit_radius*Math.sin(rads), X0 + 2*orbit_radius*Math.cos(rads)
    orb.ellipse(x, y, 2*radius, 2*radius, 0, 359)
    orb
  end

  def sundisk(radius)
    orb = Draw.new
    orb.fill = "yellow"
    orb.stroke("black")
    orb.stroke_width(1)
    orb.ellipse(X0, Y0, 2*radius, 2*radius, 0, 359)
    orb
  end

  def orbit(radius, color)
    track = Draw.new
    track.fill = "black"
    track.stroke(color)
    track.stroke_width(1)
    track.ellipse(X0, Y0, 2*radius, 2*radius, 0, 359)
    track
  end

  #########

  def self.set(sym, val)
    Module.remove_const(sym)
    self.const_set(sym, val)
  end

  def initialize(edegrees, mdegrees, filename)
    sunr = 10  # Like constants
    eor  = 50 
    mor  = 90 
    erad =  5
    mrad =  3

    @img = Image.new(Wide, High) { self.background_color = "black" }

    morb = orbit(mor, "red")
    eorb = orbit(eor, "blue")

    earth = disk(edegrees, eor, erad, "blue")
    mars  = disk(mdegrees, mor, mrad, "red")
    sun   = sundisk(sunr)

    stuff = [morb, eorb, sun, earth, mars]
    stuff.each {|item| item.draw(@img) }

    @img.write(filename)
  end

  def self.make_image(edegrees, mdegrees, filename)
    obj = self.new(edegrees, mdegrees, filename)
  end
end

