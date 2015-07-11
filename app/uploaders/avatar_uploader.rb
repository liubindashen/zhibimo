# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  retina!

  storage :file

  def store_dir
    "uploads/avatars/#{model.username}"
  end

  def default_url(*args)
    "/images/default_avatar.png"
  end

  process resize_to_fit: [96, 96]

  version :small do
    process resize_to_fit: [96, 96]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
