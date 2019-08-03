$LOAD_PATH << "."

require 'orbit_image'
require 'orbit_data'

start = Time.new(1920, 1, 1)
stop  = Time.new(2030, 1, 1)

puts Time.now

now   = start
points = 0   # data points...
loop do
  break if now > stop
  now = start + points*86400
  y, m, d = now.year, now.month, now.day
  edeg, mdeg = OrbitalCalculations.calculate(now)
  img = "images/#{y}-#{'%02d' % m}-#{'%02d' % d}.jpg"
  EarthMarsOrbits.make_image(edeg, mdeg, img)
  points += 1
end

puts Time.now
