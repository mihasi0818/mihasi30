class PostsController < ApplicationController
  include Pagy::Backend
  before_action :paginate_posts, only: [:index, :most_liked, :show]
  before_action :set_user, only: [:destroy]
  before_action :check_user_and_post, only: [:show]
  before_action :login_required, only: [:new, :create, :edit, :update, :destroy]
  
  def paginate_posts
    posts_to_paginate = @posts&.pluck(:id) || []
    posts_to_paginate = Post.where(id: posts_to_paginate)
    @pagy, @posts = pagy(posts_to_paginate.presence || Post.all, items: 10)


  end

  # app/controllers/posts_controller.rb
  def index
    order_by = params[:order_by] || ''
    @posts = case order_by
             when 'created_at_desc'
               Post.order(created_at: :desc)
             when 'created_at_asc'
               Post.order(created_at: :asc)
             when 'likes_desc'
               Post.joins(:likes).group(:id).order('COUNT(likes.id) DESC')
             else
               Post.all.order(created_at: :desc)
             end
    @posts = @posts.reverse_order if order_by == 'likes_desc'

    # 名前検索
    image_data = [
      { "name" => "火炎弾", "path" => "/images/skill/60746.webp" },
        { "name" => "執行", "path" => "/images/skill/Execute.webp" },
        { "name" => "浄化", "path" => "/images/skill/Purify.webp" },
        { "name" => "回復の泉", "path" => "/images/skill/60742.webp" },
        { "name" => "報復", "path" => "/images/skill/60749.webp" },
        { "name"=>"瞬間移動", "path" => "/images/skill/60747.webp" },
        { "name" =>"回復の泉", "path" => "/images/skill/60742.webp" },
        { "name" =>"石化", "path" => "/images/skill/60744.webp" },
        { "name"=>"アリス(Alice)", "path" => "/images/Tank/Hero041-icon.webp" },
                      { "name" =>"ティグラル", "path" => "/images/Tank/Hero061-icon.webp" },
                      { "name" =>"ガイ", "path" => "/images/Tank/Hero091-icon.webp" },
                      { "name" =>"フランコ", "path" => "/images/Tank/Hero101-icon.webp" },
                      { "name" =>"ミノタウル", "path" => "/images/Tank/Hero191-icon.webp" },
                      { "name" =>"ロイン", "path" => "/images/Tank/Hero201-icon.webp" },
                      { "name" =>"ルビー", "path" => "/images/Tank/Hero291-icon.webp" },
                      { "name" =>"ジェイソン", "path" => "/images/Tank/Hero321-icon.webp" },
                      { "name" =>"ヒルダ", "path" => "/images/Tank/Hero351-icon.webp" },
                      { "name" =>"ガトートカチャ", "path" => "/images/Tank/Hero411-icon.webp" },
                      { "name" =>"ガレック", "path" => "/images/Tank/Hero4441-icon.webp" },
                      { "name" =>"ヒロス", "path" => "/images/Tank/Hero491-icon.webp" },
                      {"name"=> "ウラノス(Uranus)", "path"=>"/images/Tank/Hero591-icon.webp"},
                      {"name" =>"ベレリック(Belerick)", "path"=>"/images/Tank/Hero701-icon.webp"},
                      {"name" =>"クッフラー(Khufra)","path"=>"/images/Tank/Hero781-icon.webp"},
                      { "name" =>"エスメラルダ(Esmeralda)","path"=>"/images/Tank/Hero811-icon.webp"},
                      {"name" =>"ゲンハ(Baxia)","path"=>"/images/Tank/Hero871-icon.webp"},
                      {"name" =>"マーシャ(Masha)","path"=>"/images/Tank/Hero881-icon.webp"},
                      {"name" =>"アテラス(Atlas)","path"=>"/images/Tank/Hero931-icon.webp"},
                      {"name" =>"バラッツ(Barats)","path"=>"/images/Tank/Hero991-icon.webp"},
                      {"name" =>"グルー(Gloo)","path"=>"/images/Tank/Hero1041-icon.webp"},
                      {"name" =>"イーディス(Edith)","path"=>"/images/Tank/Hero1111-icon.webp"},
                      {"name" =>"フレッドリン(Fredrinn)","path"=>"/images/Tank/Hero1171-icon.webp"},
                      {"name" =>"アルカード(Alucard)","path"=>"/images/fighter/Hero071-icon.webp"},
                      {"name" =>"ベイン(Bane)","path"=>"/images/fighter/Hero111-icon.webp"},
                      {"name" =>"シリュウ(Zilong)","path"=>"/images/fighter/Hero161-icon.webp"},
                      {"name" =>"フレイヤ(Freya)","path"=>"/images/fighter/Hero221-icon.webp"},
                      {"name" =>"シュウ(Chou)","path"=>"/images/fighter/Hero261-icon.webp"},
                      {"name" =>"ゴクウ(Sun)","path"=>"/images/fighter/Hero271-icon.webp"},
                      {"name" =>"アルファ(Alpha)","path"=>"/images/fighter/Hero281-icon.webp"},
                      {"name" =>"ルビー(Ruby)","path"=>"/images/fighter/Hero291-icon.webp"},
                      {"name" =>"ヒルダ(Hilda)","path"=>"/images/fighter/Hero351-icon.webp"},
                      {"name" =>"ラプラプ(Lapu-Lapu)","path"=>"/images/fighter/Hero371-icon.webp"},
                      {"name" =>"ロジャー(Roger)","path"=>"/images/fighter/Hero391-icon.webp"},
                      {"name" =>"ガトートカチャ(Gatotkaca)","path"=> "/images/fighter/Hero411-icon.webp"},
                      {"name" =>"アルゴス(Argus)","path"=> "/images/fighter/Hero451-icon.webp"},
                      {"name" =>"メタルヘッド(Jawhead)","path"=> "/images/fighter/Hero541-icon.webp"},
                      {"name" =>"マーティス(Martis)","path"=>"/images/fighter/Hero581-icon.webp"},
                      {"name" =>"カチャ(Kaja)","path"=>"/images/fighter/Hero621-icon.webp"},
                      {"name" =>"アルダス(Aldous)","path"=> "/images/fighter/Hero641-icon.webp"},
                      {"name" =>"レオモルド(Leomord)","path"=> "/images/fighter/Hero671-icon.webp"},
                      {"name"=>"デームス(Thamuz)","path"=> "/images/fighter/Hero721-icon.webp"},
                      {"name" =>"マイシータール(Minsitthar)","path"=>"/images/fighter/Hero741-icon.webp"},
                      {"name" =>"バターン(Badang)","path"=>"/images/fighter/Hero771-icon.webp"},
                      {"name" =>"グィネヴィア(Guinevere)","path"=>"/images/fighter/Hero801-icon.webp"},
                      {"name" =>"ディスラー(Terizla)","path"=> "/images/fighter/Hero821-icon.webp"},
                      {"name" =>"エックス(X.Borg)","path"=>"/images/fighter/Hero831-icon.webp"},
                      {"name" =>"ディアス(Dyrroth)","path"=>"/images/fighter/Hero851-icon.webp"},
                      {"name" =>"マーシャ(Masha)","path"=>"/images/fighter/Hero881-icon.webp"},
                      {"name" =>"シルバンナ(Silvanna)","path"=>"/images/fighter/Hero901-icon.webp"},
                      {"name" =>"ゾン(Yu Zhong)","path"=>"/images/fighter/Hero951-icon.webp"},
                      {"name" =>"カレード(Khaleed)","path"=>"/images/fighter/Hero981-icon.webp"},
                      {"name" =>"バラッツ(Barats)","path"=> "/images/fighter/Hero991-icon.webp"},
                      {"name" =>"パキート(Paquito)","path"=> "/images/fighter/Hero1031-icon.webp"},
                      {"name" =>"フォヴィウス(Phoveus)","path"=> "/images/fighter/Hero1061-icon.webp"},
                      {"name" =>"アウルス(Aulus)","path"=>"/images/fighter/Hero1081-icon.webp"},
                      {"name" =>"イン(Yin)","path"=>"/images/fighter/Hero1131-icon.webp"},
                      {"name" =>"ジュリアン(Julian)","path"=> "/images/fighter/Hero1161-icon.webp"},
                      {"name" =>"フレッドリン(Fredrinn)","path"=>"/images/fighter/Hero1171-icon.webp"},
                      {"name" =>"アーロット(Arlott)","path"=>"/images/fighter/Hero1201-icon.webp"},
                      {"name"=>"アリス(Alice)","path"=>"/images/mage/Hero041-icon.webp"},
                      {"name" =>"ナナ(Nana)","path"=>"/images/mage/Hero051-icon-1.webp"},
                      {"name" =>"ペイン(Bane)","path"=>"/images/mage/Hero111-icon.webp"},
                      {"name" =>"エウドラ(Eudora)","path"=>"/images/mage/Hero151-icon.webp"},
                      {"name" =>"グールド(Gord)","path"=>"/images/mage/Hero231-icon.webp"},
                      {"name" =>"カグラ(Kagura)","path"=>"/images/mage/Hero251-icon.webp"},
                      {"name" =>"サイクロプス(Cyclops)","path"=>"/images/mage/Hero331-icon.webp"},
                      {"name" =>"オーロラ(Aurora)","path"=>"/images/mage/Hero361-icon.webp"},
                      {"name" =>"サナ(Vexana)","path"=>"/images/mage/Hero381-icon.webp"},
                      {"name" =>"ハーリー(Harley)","path"=>"/images/mage/Hero421-icon.webp"},
                      {"name" =>"オデット(Odette)","path"=>"/images/mage/Hero461-icon.webp"},
                      {"name" =>"ザスク(Zhask)","path"=>"/images/mage/Hero501-icon.webp"},
                      {"name" =>"ファーサP(harsa)","path"=>"/images/mage/Hero521-icon.webp"},
                      {"name" =>"ヴァリル(Valir)","path"=>"/images/mage/Hero571-icon.webp"},
                      {"name" =>"嫦娥(Chang'e)","path"=>"/images/mage/Hero611-icon.webp"},
                      {"name" =>"セリナ(Selena)","path"=>"/images/mage/Hero631-icon.webp"},
                      {"name"=>"ヴェル(Vale)","path"=>"/images/mage/Hero661-icon.webp"},
                      {"name" =>"星夢(Lunox) ","path"=>"/images/mage/Hero681-icon.webp"},
                      {"name" =>"ジミー(Kimmy)","path"=>"/images/mage/Hero711-icon.webp"},
                      {"name" =>"ハリス(Harith) ","path"=>"/images/mage/Hero731-icon.webp"},
                      {"name" =>"カティタ(Kadita) ","path"=>"/images/mage/Hero751-icon.webp"},
                      {"name" =>"ファラミス(Faramis)","path"=>"/images/mage/Hero761-icon.webp"},
                      {"name" =>"エスメラルダ(Esmeralda) ","path"=>"/images/mage/Hero811-icon.webp"},
                      {"name" =>"リリア(Lylia) ","path"=>"/images/mage/Hero861-icon.webp"},
                      {"name" =>"セシリオン(Cecilion) ","path"=>"/images/mage/Hero911-icon.webp"},
                      {"name" =>"ローイー(Luo Yi)","path"=>"/images/mage/Hero961-icon.webp"},
                      {"name" =>"イブ(Yve)","path"=>"/images/mage/Hero1101-icon.webp"},
                      {"name" =>"バレンティナ(Valentina)","path"=>"/images/mage/Hero1011-icon.webp"},
                      {"name" =>"ザビエル(Xavier)","path"=>"/images/mage/Hero1151-icon.webp"},
                      {"name" =>"ジェリアン(Julian)","path"=>"/images/mage/Hero1161-icon.webp"},
                      {"name" =>"ノバリア(Novaria)","path"=>"/images/mage/Hero1191-icon.webp"},
                      {"name"=>"セイバー(Saber)","path"=> "/images/asasin/Hero031-icon.webp"},
                      {"name" =>"アルカード(Alucard)","path"=> "/images/asasin/Hero071-icon.webp"},
                      {"name" =>"カリナ(Karina)","path"=>"/images/asasin/Hero081-icon.webp"},
                      {"name" =>"子龍(Zilong)","path"=>"/images/asasin/Hero161-icon.webp"},
                      {"name" =>"ファニー(Fanny) ","path"=>"/images/asasin/Hero171-icon-1.webp"},
                      {"name" =>"隼(Hayabusa)","path"=>"/images/asasin/Hero211-icon.webp"},
                      {"name" =>"ナタリア(Natalia)","path"=>"/images/asasin/Hero241-icon.webp"},
                      {"name" =>"イスンシン(YiSun-shin)","path"=> "/images/asasin/Hero301-icon.webp"},
                      {"name" =>"ハーリー(Harley)","path"=>"/images/asasin/Hero421-icon.webp"},
                      {"name" =>"ランスロット(Lancelot)","path"=>"/images/asasin/Hero471-icon.webp"},
                      {"name" =>"ハカート(Helcurt)","path"=> "/images/asasin/Hero511-icon.webp"},
                      { "name"=>"ラズリー(Lesley)","path"=>"/images/asasin/Hero531-icon.webp"},
                      {"name" =>"ゴゼン(Gusion)","path"=> "/images/asasin/Hero561-icon.webp"},
                      {"name" =>"セリナ(Selena)","path"=>"/images/asasin/Hero631-icon.webp"},
                      {"name" =>"半蔵(Hanzo)","path"=> "/images/asasin/Hero691-icon.webp"},
                      {"name" =>"カティタ(Kadita)","path"=>"/images/asasin/Hero751-icon.webp"},
                      {"name" =>"リン(Ling)","path"=>"/images/asasin/Hero841-icon.webp"},
                      {"name" =>"ベラ(Benedetta)","path"=>"/images/asasin/Hero971-icon.webp"},
                      {"name" =>"マチルダ(Mathilda)","path"=>"/images/asasin/Hero1021-icon.webp"},
                      {"name" =>"アモン(Aamon)","path"=>"/images/asasin/Hero1091-icon.webp"},
                      {"name" =>"ジョイ(joy)","path"=>"/images/asasin/Hero1181-icon.webp"},
                      {"name" =>"アーロット(Arlott)","path"=>"/images/asasin/Hero1201-icon.webp"},
                      { "name"=>"マイヤ(Miya) ","path"=>"/images/hanter/Hero011-icon.webp"},
                      { "name" =>"ブルーノ(Bruno)","path"=>"/images/hanter/Hero121-icon.webp"},
                      { "name" =>"クリント(Clint) ","path"=>"/images/hanter/Hero131-icon.webp"},
                      { "name" =>"ライラ(Layla)","path"=>"/images/hanter/Hero181-icon.webp"},
                      { "name" =>"イスンシン(YiSun-Shin)","path"=>"/images/hanter/Hero301-icon.webp"},
                      { "name" =>"モスコブ(Moskov)","path"=>"/images/hanter/Hero311-icon.webp"},
                      { "name" =>"ロジャー(Roger)","path"=>"/images/hanter/Hero391-icon.webp"},
                      { "name" =>"キャリー(Karrie)","path"=>"/images/hanter/Hero401-icon.webp"},
                      { "name" =>"エレシル(Lrithel) ","path"=>"/images/hanter/Hero431-icon.webp"},
                      { "name" =>"ラズリー(Lesley)","path"=>"/images/hanter/Hero531-icon.webp"},
                      { "name"=>"ハナビ(Hanabi)","path"=> "/images/hanter/Hero601-icon.webp"},
                      { "name" =>"クラウド(Claude) ","path"=>"/images/hanter/Hero651-icon.webp"},
                      { "name" =>"ジミー(Kimmy)","path"=>"/images/hanter/Hero711-icon.webp"},
                      { "name" =>"グレンジャー(Granger)","path"=> "/images/hanter/Hero791-icon.webp"},
                      { "name" =>"琥珀(WanWan)","path"=>"/images/hanter/Hero891-icon.webp"},
                      { "name" =>"ボボル＆クバ(PopolandKupa)","path"=>"/images/hanter/Hero941-icon.webp"},
                      { "name" =>"ブロディ(Brody)","path"=>"/images/hanter/Hero1001-icon.webp"},
                      { "name" =>"ビアトリクス(Beatrix)","path"=>"/images/hanter/Hero1051-icon.webp"},
                      { "name" =>"ニュート(Natan)","path"=>"/images/hanter/Hero1071-icon.webp"},
                      { "name" =>"イーディス(Edith)","path"=>"/images/hanter/Hero1111-icon.webp"},
                      { "name" =>"メリッサ(Melissa)","path"=>"/images/hanter/Hero1141-icon.webp"},
                      { "name"=>"ナナ(Nana)","path"=>"/images/support/Hero051-icon.webp"},
                      { "name" =>"ティグラル(Tigreal)","path"=>"/images/support/Hero061-icon.webp"},
                      { "name" =>"ガイ(Akai)","path"=>"/images/support/Hero091-icon.webp"},
                      { "name" =>"フランコ(Franco)","path"=>"/images/support/Hero101-icon.webp"},
                      { "name" =>"ラファエル(Rafaela)","path"=>"/images/support/Hero141-icon.webp"},
                      { "name" =>"ミノタウルス(Minotaur)","path"=>"/images/support/Hero191-icon.webp"},
                      { "name" =>"ロイン(Lolita)","path"=>"/images/support/Hero201-icon.webp"},
                      { "name" =>"エスタス(Estes)","path"=>"/images/support/Hero341-icon-2.webp"},
                      { "name"=>"ディガー(Diggie)","path"=> "/images/support/Hero481-icon.webp"},
                      { "name" =>"アンジェラ(Angela)","path"=>"/images/support/Hero551-icon.webp"},
                      { "name" =>"カチャ(Kaja)","path"=>"/images/support/Hero621-icon.webp"},
                      { "name" =>"マイシータール(Minsitthar)","path"=>"/images/support/Hero743-icon.webp"},
                      { "name" =>"ファミラス(Faramis)","path"=>"/images/mage/Hero761-icon.webp"},
                      { "name" =>"カーミラ(Carmilla)","path"=>"/images/support/Hero921-icon.webp"},
                      { "name" =>"アテラス(Atlas)","path"=>"/images/support/Hero931-icon.webp"},
                      { "name" =>"マチルダ(Mathilda)","path"=>"/images/support/Hero1021-icon.webp"},
                      { "name" =>"フローラ(Floryn)","path"=>"/images/support/Hero1121-icon.webp"}
                         ]

    if params[:search].present?
      search_term = params[:search].downcase
      @posts = @posts.select do |post|
        image_data.any? { |data| data["name"].downcase.include?(search_term) && (data["path"] == post.image_url1.to_s || data["path"] == post.image_url40.to_s) }
      end
    end

    paginate_posts
    @post = Post.first
    @remaining_time = @post ? @post.remaining_time : { days: 0, hours: 0, minutes: 0, seconds: 0 }

    @image_data = image_data
  end
  
    
    
  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "投稿が作成されました"
      redirect_to @post
    else
      flash.now[:error] = "エラー：投稿を保存できませんでした - #{@post.errors.full_messages}"
      render :new
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    if !@post || !current_user
      flash[:error] = "投稿が見つかりませんでした。" if !@post
      flash[:alert] = "ログインしてください。" if !current_user
      redirect_to posts_path and return
    end

    @like = Like.find_by(user_id: current_user.id, post_id: @post.id) if current_user

    @comment = Comment.new
    @pagy, @comments = pagy(@post.comments.order(created_at: :desc), items: 5)
  end

  def edit
  end



  def edit
  end
  
  def update
    if @post.update(post_params)
      redirect_to @post, notice: '投稿が正常に更新されました。'
    else
      render :edit
    end
  end
  
  def destroy
    @post = Post.find_by(id: params[:id])
    if @post.nil?
      flash[:alert] = "投稿が見つかりませんでした。"
      redirect_to root_path and return
    end
  
    if current_user.email == "guest@example.com"
      flash[:alert] = "ゲストユーザーは投稿を削除することはできません。"
      redirect_to root_path and return
    end
  
    if current_user.id != @post.user_id
      flash[:alert] = "投稿の所有者ではありません。"
      redirect_to root_path and return
    end
  
    if @post.destroy
      flash[:notice] = "投稿を削除しました。"
      redirect_to user_path(current_user)
    else
      flash[:alert] = "投稿の削除に失敗しました。"
      redirect_to user_path(current_user)
    end
  end
  
  
  def most_liked
    set_pagy_posts
    @posts = Post.left_joins(:likes)
                 .select("posts.*, count(likes.id) as like_count")
                 .group("posts.id")
                 .order('like_count DESC')
  
    # 最も「いいね！」の数が多い投稿を取得し、その投稿を先頭に追加
    @most_liked_post = @posts.first
  
    render :index
  end
  
  def like
    if current_user.likes.find_by(post_id: params[:id])
      flash[:alert] = 'この投稿にはすでにいいねしています。'
    else
      Like.create(user_id: current_user.id, post_id: params[:id])
      flash[:notice] = '投稿にいいねしました。'
    end
    redirect_back(fallback_location: root_path)
  end
  

  
  
private

def post_params
 params.require(:post).permit(:image_url1, :image_url2, :image_url22, :image_url23, :image_url3, :image_url33, :image_url34, :content, :image_url40, :image_url41, :image_url42, :image_url43, :image_url44)
end



def set_user
 if params[:user_id].present?
   @user = User.find_by(id: params[:user_id])
   unless @user
     # ユーザーが存在しない場合の処理
   end
 else
   # user_idパラメータが欠落している場合の処理
 end
end

def check_user_and_post
 @post = Post.find_by(id: params[:id])
 unless @post && current_user
   if !@post
     flash[:error] = "投稿が見つかりませんでした。"
   elsif !current_user
     flash[:alert] = "ログインしてください。"
   end
   redirect_to posts_path and return
 end
end
 
def login_required
 redirect_to login_url unless current_user
end



end