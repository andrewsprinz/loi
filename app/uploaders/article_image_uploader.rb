# encoding: utf-8

class ArticleImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumbnail do
    process :resize_to_fill => [317,220]
  end
  
  version :panel do 
    process :resize_to_fit => [750,nil] 
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
