# frozen_string_literal: true

class ArticlesController < ApplicationController
  http_basic_authenticate_with name: 'morron', password: 'secret', except: %i[index show]

  def index
    @articles = Article.paginate(page: params[:page], per_page: 10)
    @articles = Article.filter_by_topic(params[:topic]) if params[:topic].present?
  end

  def show
    @article = Article.find(params[:id])
    @comments = @article.comments.paginate(page: params[:page], per_page: 3)
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render 'new'
    end
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to articles_path
  end

  def filter_between_previous_version
    @articles = Article.find(params[:topic])
  end

  private

  def article_params
    params.require(:article).permit(:title, :text, :topic)
  end
end
