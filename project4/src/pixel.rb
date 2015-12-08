class Pixel
  def initialize(r, g, b)
    @r = r
    @g = g
    @b = b
  end

  def r; @r end
  def g; @g end
  def b; @b end

  def -(color)
    return nil unless color.is_a? Pixel
    new_r = (r - color.r).abs
    new_g = (g - color.g).abs
    new_b = (b - color.b).abs

    new_r + new_g + new_b
  end
end