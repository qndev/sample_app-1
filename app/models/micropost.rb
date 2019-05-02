class Micropost < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.leng}
  validate  :picture_size

  scope :micropost_desc, ->{order created_at: :desc}

  mount_uploader :picture, PictureUploader

  private

  def picture_size
    return unless picture.size > Settings.image_size.megabytes
    errors.add :picture, I18n.t("image_size")
  end
end
