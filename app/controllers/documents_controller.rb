class DocumentsController < ApplicationController
  before_action :authorize_web
  before_action :set_locale
  skip_authorization_check

  PER_PAGE = 30

  def index
    page = params[:page].to_i
    page = 1 if page < 1

    offset = (page - 1) * PER_PAGE

    @documents = Document.order(created_at: :desc).limit(PER_PAGE).offset(offset)

    total_count = Document.count
    @total_pages = (total_count.to_f / PER_PAGE).ceil
    @current_page = page
  end
end
