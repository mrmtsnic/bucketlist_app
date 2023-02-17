class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # アップロードした画像の表示
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # デフォルト画像の設定
  def default_url
    "default.png" # assets/images/に置けばok
  end

  # アップロードファイルの指定
  def extension_allowlist
    %w(jpg jpeg png)
  end

  # 画像をリサイズ
  version :thumb do
    process resize_to_fit: [150, 150]
  end

end
