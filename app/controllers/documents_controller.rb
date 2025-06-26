class DocumentsController < ApplicationController
  before_action :authorize_web
  before_action :set_locale
  skip_authorization_check

  def index
    @documents = Document.all
    render :layout => false
  end
end
