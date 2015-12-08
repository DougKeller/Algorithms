class Image
  def initialize(name, pixels, type)
    @name = name
    @pixels = pixels
    @type = type
  end

  def name; @name end
  def pixels; @pixels end
  def height; @pixels.size end
  def width; @pixels.empty? ? 0 : @pixels.first.size end
  def type; @type end

  def ext_name
    type == 'P2' ? '.pgm' : '.ppm'
  end

  def highlight_vertical_seam
    highlight vertical_seam
  end

  def highlight_horizontal_seam
    highlight horizontal_seam
  end

  def remove_vertical_seam
    return if width == 0

    seam = vertical_seam

    seam.each do |pos|
      row, col = [pos.first, pos.last]
      pixels[row].delete_at col
    end
  end

  def remove_horizontal_seam
    return if height == 0

    removed = horizontal_seam

    removed.each do |pos|
      row, col = [pos.first, pos.last]

      pixels.each_index do |r|
        next if r < row || r >= height - 1
        pixels[r][col] = pixels[r + 1][col]
      end
    end
    pixels.delete_at(height - 1)
  end

  def energy_image
    Image.grayscale_from_matrix energy_matrix, name
  end

  def vertical_seam_image
    Image.grayscale_from_matrix vertical_seam_matrix, name
  end

  def horizontal_seam_image
    Image.grayscale_from_matrix horizontal_seam_matrix, name
  end

  def save(suffix = '')
    Dir.mkdir 'output' unless Dir.exist? 'output'

    content = "#{type}\n# Doug Keller\n# Algorithms - Project 4\n#{width} #{height}\n255\n"
    pixels.each do |row|
      combined = row.map { |v| v.r } if type == 'P2'
      combined = row.map { |v| [v.r, v.g, v.b] }.flatten if type == 'P3'
      content << combined.join(' ') + "\n"
    end

    File.write "output/#{name}#{suffix}#{ext_name}", content
  end

  private

  def highlight(seam)
    seam.each_index do |i|
      row, col = seam[i]
      pixels[row][col] = Pixel.new(0, 0, 0) if i % 2 == 0
      pixels[row][col] = Pixel.new(255, 255, 255) if i % 2 == 1
    end
  end

  def vertical_seam
    seam_matrix = vertical_seam_matrix

    seam = []

    height.times do |i|
      row = height - i - 1
      col = nil

      full_row = seam_matrix[row]

      if seam.empty?
        min = full_row.min
        col = full_row.find_index min
      else
        prev_col = seam.last[1]
        start_index = [prev_col - 1, 0].max
        end_index = [prev_col + 1, width - 1].min

        sub_row = full_row[start_index .. end_index]
        min = sub_row.min
        col = sub_row.find_index(min) + start_index
      end

      seam << [row, col]
    end

    seam
  end

  def horizontal_seam
    seam_matrix = horizontal_seam_matrix

    seam = []

    width.times do |i|
      row = nil
      col = width - i - 1

      full_column = seam_matrix.map { |r| r[col] }

      if seam.empty?
        min = full_column.min
        row = full_column.find_index(min)
      else
        prev_row = seam.last[0]
        start_index = [prev_row - 1, 0].max
        end_index = [prev_row + 1, height - 1].min

        sub_column = full_column[start_index .. end_index]
        min = sub_column.min
        row = sub_column.find_index(min) + start_index
      end

      seam << [row, col]
    end

    seam
  end

  def vertical_seam_matrix
    energies = energy_matrix
    seam_matrix = []

    height.times do |r|
      row = []
      width.times do |c|
        previous = []
        if r > 0
          previous << seam_matrix[r - 1][c - 1] if c > 0
          previous << seam_matrix[r - 1][c]
          previous << seam_matrix[r - 1][c + 1] if c < width - 1
        end

        row << energies[r][c] + (previous.min || 0)
      end
      seam_matrix << row
    end
    seam_matrix
  end

  def horizontal_seam_matrix
    energies = energy_matrix
    seam_matrix = []

    width.times do |c|
      height.times do |r|
        seam_matrix << [] if r >= seam_matrix.size
        previous = []
        if c > 0
          previous << seam_matrix[r - 1][c - 1] if r > 0
          previous << seam_matrix[r][c - 1]
          previous << seam_matrix[r + 1][c - 1] if r < height - 1
        end

        seam_matrix[r] << energies[r][c] + (previous.min || 0)
      end
    end
    seam_matrix
  end

  def energy_matrix
    energies = []
    height.times do |r|
      row = []
      width.times do |c|
        row << energy_at(r, c)
      end
      energies << row
    end
    energies
  end

  def energy_at(r, c)
    pixel = @pixels[r][c]
    adjacent = []

    adjacent << @pixels[r - 1][c] if r > 0
    adjacent << @pixels[r][c - 1] if c > 0
    adjacent << @pixels[r + 1][c] if r < (height - 1)
    adjacent << @pixels[r][c + 1] if c < (width - 1)

    energy = 0
    adjacent.each { |v| energy += (pixel - v) }
    energy
  end

  def self.ext_name(head)
    head == 'P2' ? '.pgm' : '.ppm'
  end

  def self.from_file(path)
    lines = []
    IO.foreach(path) { |line| lines << line }

    type = (lines.delete_at 0).chomp!
    lines.delete_at 0 while lines[0].include? '#'

    width, height = lines[0].split(' ').map { |v| v.to_i }

    lines = lines.drop 2
    values = lines.join(' ').gsub(/\s+/, ' ').split(' ').map { |v| v.to_i }

    pixels = []
    name = File.basename path, ext_name(type)

    until values.empty?
      if type == 'P2'
        pixels << values.first(width).map { |v| Pixel.new v, v, v }
        values = values.drop width
      elsif type == 'P3'
        row = []
        values.first(width * 3).each_slice(3) do |trip|
          row << Pixel.new(trip[0], trip[1], trip[2])
        end
        pixels << row
        values = values.drop width * 3
      end
    end

    raise LoadError if pixels.size != height

    Image.new name, pixels, type
  end

  def self.grayscale_from_matrix(matrix, name)
    max_value = 0
    matrix.each do |row|
      max_value = [max_value, row.max].max
    end

    matrix.each do |row|
      row.map! do |v|
        gs = (v * 255.0 / max_value).floor
        Pixel.new gs, gs, gs
      end
    end

    Image.new name, matrix, 'P2'
  end
end