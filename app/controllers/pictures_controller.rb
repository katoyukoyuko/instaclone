class PicturesController < ApplicationController
  # before_action :set_picture, only: [:show, :edit, :update, :destroy, :confirm]
  before_action :set_picture, only: [:show, :edit, :update, :destroy]

  # GET /pictures
  # GET /pictures.json
  def index
    @pictures = Picture.all
  end

  # GET /pictures/1
  # GET /pictures/1.json
  def show
    @favorite = current_user.favorites.find_by(picture_id: @picture.id)
  end

  # GET /pictures/new
  def new
    if params[:back]
      @picture = Picture.new(picture_params)
    else
      @picture = Picture.new
    end
  end

  # GET /pictures/1/edit
  def edit
    @picture.image.cache!
  end

  # POST /pictures
  # POST /pictures.json
  def create
    @picture = Picture.new(picture_params)
    @picture.user_id = current_user.id
    if params[:back]
      render :new
    else
        respond_to do |format|
          if @picture.save
            format.html { redirect_to @picture, notice: 'Picture was successfully created.' }
            format.json { render :show, status: :created, location: @picture }
          else
            format.html { render :new }
            format.json { render json: @picture.errors, status: :unprocessable_entity }
          end
        end
    end
  end

  # PATCH/PUT /pictures/1
  # PATCH/PUT /pictures/1.json
  def update
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to @picture, notice: 'Picture was successfully updated.' }
        format.json { render :show, status: :ok, location: @picture }
      else
        format.html { render :edit }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.json
  def destroy
    @picture.destroy
    respond_to do |format|
      format.html { redirect_to pictures_url, notice: 'Picture was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def confirm
    @picture = current_user.pictures.build(picture_params)
    # @picture = current_user.pictures.new(picture_params)

    # @picture = Picture.new(picture_params)
    # @picture.user_id = current_user.id
  end
  
=begin
・new
formに画像を登録した段階でcarrierwaveの機能で、@pictureのインスタンスにcacheができる
@picture.image_cache が入っているので、キャッシュが表示される 

・edit
[編集 - 確認]
@pictureのインスタンスにcacheが登録されていないので、キャッシュが出ない
@pictureのインスタンスにcacheを登録させたい
- edit action
cacheの登録は画像が保存されているインスタンスに対して、@picture.image.cache!で作成される
- render :edit
confirmのformに画像のキャッシュが表示される

[確認 - 更新]
confirmのform.hidden_fieldでimage_cacheをparameterに登録する
paramterから受け取ったimage_cacheを@update(picture_paramsに渡す)
confirmでupdateアクションで@pictureのインスタンスにcacheを入れて更新する
cacheがない状態で、
=end

# [めも]Gem : アクティブストレージを使うときは confirm難しくなる https://railsguides.jp/active_storage_overview.html


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_picture
      @picture = Picture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def picture_params
      params.require(:picture).permit(:image, :content, :image_cache)
    end
end