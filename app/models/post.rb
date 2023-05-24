class Post < ApplicationRecord
  scope :newest_first, -> { order(created_at: :desc) }
  scope :oldest_first, -> { order(created_at: :asc) }
  scope :most_liked, -> { joins(:likes).group(:id).order('COUNT(likes.id) DESC') }

  



  before_create :set_countdown_end_date
 
  
  belongs_to :user
  validates :user_id, presence: true
  #コメント機能


  validates :comments,
          length: { maximum: 100 }

has_many :comments, dependent: :destroy

validates :content,
          length: { maximum: 1000 }

  


  
  #必ず投稿しないといけないようにする
  validates :image_url1, :image_url2, :image_url3, :image_url40, presence: true
#任意機能
  validates :image_url22, presence: true, allow_blank: true
  validates :image_url23, presence: true, allow_blank: true
  validates :image_url33, presence: true, allow_blank: true
  validates :image_url34, presence: true, allow_blank: true


 #team
  validates :image_url41, presence: true, allow_blank: true
  validates :image_url42, presence: true, allow_blank: true
  validates :image_url43, presence: true, allow_blank: true
  validates :image_url44, presence: true, allow_blank: true


  validates :name, presence: true, allow_blank: true

  
  def set_countdown_end_date(date = nil)
    # `set_countdown_end_date`メソッドの実装
    self.countdown_end_date = date
  end
 #いいね機能
  has_many :likes, dependent: :destroy
  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  def likes_count
    likes.count
  end

  def remaining_time
  target_date = created_at + 50.days
  remaining_seconds = (target_date - Time.current).to_i
  {
    days: remaining_seconds / (60 * 60 * 24),
    hours: (remaining_seconds / (60 * 60)) % 24,
    minutes: (remaining_seconds / 60) % 60,
    seconds: remaining_seconds % 60
  }
end

# 一番古い投稿に`remaining_time`メソッドを適用する例
oldest_post = Post.order(:created_at).first
time_remaining = oldest_post.remaining_time
puts "一番古い投稿の残り時間: #{time_remaining[:days]}日 #{time_remaining[:hours]}時間 #{time_remaining[:minutes]}分 #{time_remaining[:seconds]}秒"

#この機能とは
  def author
    User.find_by(id: user_id) if user_id.present?
  end
  

  def related_posts
    Post.where(user_id: user_id).where.not(id: id)
  end


end