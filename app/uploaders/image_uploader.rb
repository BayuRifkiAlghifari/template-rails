class ImageUploader < Shrine
  IMAGE_TYPES = %w[image/jpg image/jpeg image/png image/webp image/svg]
  VIDEO_TYPES = %w[video/mp4 video/quicktime]
  PDF_TYPES   = %w[application/pdf]
 
  Attacher.validate do
    validate_max_size 5*1024*1024
    validate_mime_type IMAGE_TYPES + VIDEO_TYPES + PDF_TYPES
  end
 
  Attacher.derivatives do |original|
    case file.mime_type
      when *IMAGE_TYPES then process_derivatives(:image, original)
      when *VIDEO_TYPES then process_derivatives(:video, original)
      when *PDF_TYPES   then process_derivatives(:pdf,   original)
    end
  end
 
  Attacher.derivatives :image do |original|
    magick = ImageProcessing::MiniMagick.source(original).saver(quality: 90)
    {
      large:  magick.resize_to_limit!(800, 800),
      medium: magick.resize_to_limit!(500, 500),
      small:  magick.resize_to_limit!(300, 300),
    }
  end
 
  Attacher.derivatives :video do |original|
    # ... 
  end
 
  Attacher.derivatives :pdf do |original|
    # ... 
  end

  # Fallback to original
  Attacher.default_url do |derivative: nil, **|
    file&.url if derivative
  end
end