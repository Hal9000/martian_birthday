require 'date'

class OrbitalCalculations
  Earth, Mars = 0, 1

  # Orbital elements (calculated taking into account planet's axis precession)

  PerihelionDateJD = [2454833.845, 2452881.0]    # 2452881.96111

  MeanMotionPerDay = [0.9856002907763,  # Average motion in degrees per day,
                      0.5240208088928]  #   this is 360/period

  def get_julian_date d, im, iy
    DateTime.new(iy,im,d).jd - 0.5
  end 

  def days_since_J2000 d, im, iy
    get_julian_date(d, im, iy) - 2451545.0
  end

  def get_eccentricity(planet, jd)   # eccentricity
    t = (jd - 2451545.0)/365250.0
    case planet
      when Earth
        return 0.0167086342 - 0.0004203654*t - 
               0.0000126734*(t**2)+1444e-10*(t**3) 
      when Mars
        return 0.0934006477 + 0.0009048438*t - 
               80641e-10*(t**2) - 2519e-10*(t**3)
    end 
  end 

  def get_perihelion_longitude(planet, jd)   # mean perihelion logitude, degrees
    t = (jd - 2451545.0)/365250.0
    case planet
      when Earth
        return 102.93734808 + 3.22565358*t + 
               0.014798825*(t**2) - 3.91528e-5*(t**3)
      when Mars
        return 336.06023395 + 4.43901641*t + 
               0.017313333*(t**2) - 5.17956e-4*(t**3)
    end 
  end 

  def normalize_angle(degrees)   # Step-by-step calculation process
    fullrotations = degrees.to_i / 360
    degrees.to_f - fullrotations*360.0
  end

  def r2d(radians)
    radians.to_f*180.0/Math::PI
  end

  def d2r(degrees)
    degrees.to_f*Math::PI/180.0
  end

  def calaulate_mean_anomaly(planet, jd)
    anglevalue = normalize_angle(MeanMotionPerDay[planet] * 
                 (jd - PerihelionDateJD[planet]))
  end

  def calculate_delta(mra, era, exc)
    (mra - era + exc*Math.sin(era)).abs
  end


  def calculate_eccentric_anomalyR(planet, jd, max_error)
    # successive approximation to find E (returns radians)
    meanRanomaly = d2r(calaulate_mean_anomaly(planet, jd))
    planetEccentricity = get_eccentricity(planet, jd)
    eccentricRanomaly = meanRanomaly   # starting point
    counter = 0   # just for debugging
    delta = calculate_delta(meanRanomaly, eccentricRanomaly, 
                            planetEccentricity)
    while delta > max_error
      deltaplus = calculate_delta meanRanomaly, eccentricRanomaly+delta, 
                                  planetEccentricity
      deltaminus = calculate_delta meanRanomaly, eccentricRanomaly-delta, 
                                  planetEccentricity
      if deltaplus < delta 
        eccentricRanomaly += delta
        delta = deltaplus
      else 
        if deltaminus < delta
          eccentricRanomaly -= delta
          delta = deltaminus
        else
          delta = delta/2.0 
        end
      end
      counter += 1
      if counter > 10000
        return eccentricRanomaly
      end
    end 
    return eccentricRanomaly
  end

  def calculate_true_anomaly(planet, jd, max_err)
    ecc = get_eccentricity(planet, jd)
    ecar = calculate_eccentric_anomalyR(planet, jd, max_err)
    normalize_angle(r2d(Math.atan((((1.0+ecc).to_f/(1.0-ecc).to_f)**0.5)*Math.tan(ecar.to_f/2.0))*2) + get_perihelion_longitude(planet,jd))
  end

  def get_earth_mars_angles(yyyy, mm, dd)
    vyear, vmonth, vday = yyyy, mm, dd

    # inherited weird code?
    t = Date.new(vyear, vmonth, vday)
    vyear, vmonth, vday = t.year, t.month, t.day
    vprox = 0.01

    jdate = get_julian_date(vday,vmonth,vyear)
    epos = calculate_true_anomaly(Earth, jdate, vprox)
    mpos = calculate_true_anomaly(Mars,  jdate, vprox)

    [epos, mpos]
  end

  def self.calculate(utc = ::Time.now.utc)
    obj = self.new
    obj.get_earth_mars_angles(utc.year, utc.month, utc.day)
  end

end

