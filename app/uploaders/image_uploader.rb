class ImageUploader < Shrine
  Attacher.validate do
    validate_max_size 5*1024*1024, # 5 GB
    validate_mime_type_inclusion ['image/jpg', 'image/jpeg', 'image/png', 'image/svg']
  end

  # Eager processing / derivatives processing
  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original).saver(quality: 90)
    {
      large:  magick.resize_to_limit!(800, 800),
      medium: magick.resize_to_limit!(500, 500),
      small:  magick.resize_to_limit!(300, 300),
    }
  end

  # Fallback to original
  Attacher.default_url do |derivative: nil, **|
    file&.url if derivative
  end
end