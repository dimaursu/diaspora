#   Copyright (c) 2010-2012, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class HomeController < ApplicationController

  def show
    partial_dir = Rails.root.join('app', 'views', 'home')
    if user_signed_in?
      redirect_to stream_path
    elsif partial_dir.join("_show.html.haml").exist? || partial_dir.join("_show.html.erb").exist?
      render :show, layout: 'application_offline'
    else
      render file: Rails.root.join("public", "default.html"), layout: 'application_offline'
    end
  end
end
