require_relative 'image.rb'
require_relative 'pixel.rb'
require_relative 'tools.rb'
require 'colorize'

Timer.start
path = ARGV[0]

# Load file
image = Image.from_file path
puts "Loaded #{image.width}x#{image.height} image from #{path} (#{Timer.lap})"

if ARGV.size == 2
  option = ARGV[1].downcase

  # Generate image according to option
  puts "Creating image...".blue

  processed = case option
  when 'energy'
    image.energy_image
  when 'vgradient'
    image.vertical_seam_image
  when 'hgradient'
    image.horizontal_seam_image
  when 'vseam'
    image.highlight_vertical_seam
    processed = image
  when 'hseam'
    image.highlight_horizontal_seam
    processed = image
  else
    puts 'INVALID OPTION'.red
    puts 'Valid options are: energy, vgradient, hgradient, vseam, hseam'.yellow
    exit
  end

  puts "Created image (#{Timer.lap})".green

  # Save image
  processed.save "_#{option}"

  puts "Saved #{processed.width}x#{processed.height} #{option} image (#{Timer.lap})"
else
  vertical = ARGV[1].to_i
  horizontal = ARGV[2].to_i

  # Carve vertical seams
  if vertical > 0
    puts "Removing vertical seams...".blue
    progress = Progress.new vertical
    vertical.times do
      image.remove_vertical_seam
      progress.step
    end
    progress.conclude "Removed #{vertical} vertical seams (#{Timer.lap})"
  end

  # Carve horizontal seams
  if horizontal > 0
    puts "Removing horizontal seams...".blue
    progress = Progress.new horizontal
    horizontal.times do
      image.remove_horizontal_seam
      progress.step
    end
    progress.conclude "Removed #{horizontal} horizontal seams (#{Timer.lap})"
  end

  # Save processed image
  image.save "_processed_#{vertical}_#{horizontal}"
  puts "Saved #{image.width}x#{image.height} processed image (#{Timer.lap})"

end

puts "Completed in #{Timer.elapsed}.".green