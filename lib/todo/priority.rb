# Author:: Pjotr Prins
# Copyright:: July 2007, March 2009, March 2014
# License:: Ruby License
#
# The Priority class handles priority tags based on the contained date

class Integer
  def max i
    return i if i > self
    self
  end
end

class Priority

  # Sets the date for the item - when the year has not been defined and the
  # date is more than 3 months in the past the (perhaps sensible) guess is that
  # it is for next year.

  def initialize s=''
    @pri = ""
    @original = s
    @pri = s.strip if s
    @isdate = false
    if @pri =~ /(\d+\/\d+)/
      @isdate = true
      short = $1
      guessyear = (@pri !~ /\d+\/\d+\/20/)
      @pri = short+'/'+Time.now.year.to_s if guessyear
      @pri =~ /(\d+)\/(\d+)\/(\d+)/
      year = $3
      month = $2
      day = $1
      # p [year,month,day]
      begin
        @time = Time.local(year,month,day)
        while guessyear and @time < Time.now - 3*30*24*3600
          year = year.to_i + 1
          @time = Time.local(year,month,day)
          # p [@time,@original]
        end
      rescue RangeError
        raise "RangeError in "+s
      end
      @pri = year.to_s + month + day
    end
  end

  def date?
    @isdate
  end

  # Priority expired - should have been handled before today

  def expired?
    if @isdate
      return (Time.now > @time)
    end
    false
  end

  # Item is due (2 weeks ahead)

  def due?
    if !date?
      return @pri.size > 0
    end
    return !more_than_two_weeks_away?
  end

  def more_than_two_weeks_away?
    if @isdate
      return (@time > Time.now + 14*24*3600)
    end
    false
  end

  # One month ahead

  def more_than_one_month_away?
    if @isdate
      return (Time.now + 31*24*3600 > @time)
    end
    false
  end

  def time_s
    @time.strftime("%Y%m%d-%H%M") if date?
  end

  def remind_s
    s = @time.strftime("%d %b %Y")
    s += @time.strftime(" at %H:%M") if @time.hour != 0
    s
  end

  def to_s
    if date?
      (d,m,y) = @original.strip.split(/\//)
      s = sprintf("%0.2d/%0.2d",d.to_i,m.to_i)
      s += '/'+y.to_s if y
      return s
    end
    @original.strip
  end

  def empty?
    @pri and @pri.size == 0 and not date?
  end

  def has?
    !empty?
  end

  def size
    to_s.size
  end

  def sortby
    if date?
      return time_s
    end
    @pri.rjust(30)
  end

end
