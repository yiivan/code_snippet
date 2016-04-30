class SnippetsController < ApplicationController

  before_action :authenticate_user!, except: [:show, :index]
  before_action :find_snippet, only: [:show, :edit, :update, :destroy]
  before_action :authorize_snippet, only: [:edit, :update, :destroy]
  before_action :private_snippet, only: [:show]

  def new
    @snippet = Snippet.new
  end

  def create
    @snippet = Snippet.new snippet_params
    @snippet.user = current_user
    if @snippet.save
      redirect_to snippet_path(@snippet), notice: "Snippet created!"
    else
      flash.now[:alert] = "Snippet not created!"
      render :new
    end
  end

  def show
  end

  def index
    @categories = Category.order(:id)
  end

  def edit
  end

  def update
    if @snippet.update snippet_params
      redirect_to snippet_path(@snippet), notice: "Snippet updated!"
    else
      flash.now[:alert] = "Snippet not updated!"
      render :edit
    end
  end

  def destroy
    @snippet.destroy
    redirect_to snippets_path, notice: "Snippet deleted!"
  end

  private

  def private_snippet
    redirect_to root_path unless can? :private, @snippet
  end

  def authorize_snippet
    redirect_to root_path unless can? :crud, @snippet
  end

  def find_snippet
    @snippet = Snippet.find params[:id]
  end

  def snippet_params
    params.require(:snippet).permit(:category_id, :title, :work, :private)
  end
end
