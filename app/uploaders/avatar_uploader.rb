class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def default_url *args
    ActionController::Base.helpers.asset_path("default_avatar.jpg")
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_limit: [Settings.user.avatar_height,
    Settings.user.avatar_width]

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
