# encoding: utf-8

class CoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :preview do
    process :resize_to_fit => [200, 262]
  end

  version :magazine do
    process :resize_to_fit => [1800, 2360]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
