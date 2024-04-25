class DiariesController < ApplicationController
  before_action :set_diary, only: %i(show edit update destroy)
  before_action :authenticate_user!

  # GET /diaries or /diaries.json
  def index
    @diaries = current_user.diaries
    # @user = current_user
  end

  # GET /diaries/1 or /diaries/1.json
  def show
    @diary = Diary.find(params[:id])
    if @diary.user_id != current_user.id
      flash[:notice] = "権限がありません"
      redirect_to diaries_path
    end
  end

  # GET /diaries/new
  def new
    @diary = Diary.new(start_time: params[:date]) if params[:date].present?
    # @user = current_user
  end

  # GET /diaries/1/edit
  def edit
    @diary = Diary.find(params[:id])
    if @diary.user_id != current_user.id
      flash[:notice] = "権限がありません"
      redirect_to diaries_path
    end
  end

  # POST /diaries or /diaries.json
  def create
    @diary = current_user.diaries.new(diary_params)

    respond_to do |format|
      if @diary.save
        format.html { redirect_to diary_url(@diary), notice: "Diary was successfully created." }
        format.json { render :show, status: :created, location: @diary }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @diary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /diaries/1 or /diaries/1.json
  def update
    respond_to do |format|
      if @diary.update(diary_params)
        format.html { redirect_to diary_url(@diary), notice: "Diary was successfully updated." }
        format.json { render :show, status: :ok, location: @diary }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @diary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /diaries/1 or /diaries/1.json
  def destroy
    @diary.destroy

    respond_to do |format|
      format.html { redirect_to diaries_url, notice: "Diary was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_diary
    @diary = Diary.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def diary_params
    params.require(:diary).permit(:title, :text, :start_time, :user_id)
  end
end
