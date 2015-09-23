# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/avatars/#{model.class.name.underscore}/#{model.id}"
  end

  def default_url(*args)
    "/default-avatar.png"
  end

  process resize_to_fit: [256, 256]

  version :small do
    process resize_to_fit: [96, 96]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
