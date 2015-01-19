#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class ProfilesController < ApplicationController
  before_action :authenticate_user!, :except => ['show']
  before_action -> { @css_framework = :bootstrap }, only: [:show, :edit]

  layout ->(c) { request.format == :mobile ? "application" : "with_header_with_footer" }, only: [:show, :edit]

  respond_to :html, :except => [:show]
  respond_to :js, :only => :update

  def request_verification_code
    # request a new verfication code in case that the previous one was lost
    current_user.profile.resend_another_verification_code
    flash[:notice] = "Un nou cod de verificare a fost trimis"
    redirect_to edit_profile_path
  end

  # this is terrible because we're actually serving up the associated person here;
  # however, this is the effect that we want for now
  def show
    @person = Person.find_by_guid!(params[:id])

    respond_to do |format|
      format.json { render :json => PersonPresenter.new(@person, current_user) }
    end
  end

  def edit
    @person = current_user.person
    @aspect  = :person_edit
    @profile = @person.profile

    @tags = @profile.tags
    @tags_array = []
    @tags.each do |obj|
      @tags_array << { :name => ("#"+obj.name),
        :value => ("#"+obj.name)}
      end
  end

  def update
    # upload and set new profile photo
    @profile_attrs = profile_params

    munge_tag_string

    #checkbox tags wtf
    @profile_attrs[:searchable] ||= false
    @profile_attrs[:nsfw] ||= false

    if params[:photo_id]
      @profile_attrs[:photo] = Photo.where(:author_id => current_user.person_id, :id => params[:photo_id]).first
    end

    if current_user.update_profile(@profile_attrs)
      flash[:notice] = I18n.t 'profiles.update.updated'
    else
      flash[:error] = I18n.t 'profiles.update.failed'
    end

    # activate the profile if the right code is sent here
    verify_from_message(@profile_attrs)

    respond_to do |format|
      format.js { render :nothing => true, :status => 200 }
      format.any {
        flash[:notice] = I18n.t 'profiles.update.updated'
        if current_user.getting_started?
          redirect_to getting_started_path
        else
          redirect_to edit_profile_path
        end
      }
    end
  end

  private

  def verify_from_message(params)
    profile = get_profile_for_phone_verification(params)
    profile.mark_phone_as_verified! if profile
  end

  def munge_tag_string
    unless @profile_attrs[:tag_string].nil? || @profile_attrs[:tag_string] == I18n.t('profiles.edit.your_tags_placeholder')
      @profile_attrs[:tag_string].split( " " ).each do |extra_tag|
        extra_tag.strip!
        unless extra_tag == ""
          extra_tag = "##{extra_tag}" unless extra_tag.start_with?( "#" )
          params[:tags] += " #{extra_tag}"
        end
      end
    end
    @profile_attrs[:tag_string] = (params[:tags]) ? params[:tags].gsub(',',' ') : ""
  end

  def get_profile_for_phone_verification(params)
    phone_verification_code = params[:phone_v_code]

    condition = { phone_v_code: phone_verification_code, phone: current_user.profile.phone }

    Profile.unverified_phones.where(condition).first
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :gender, :bio, :location,
                                    :locality, :county, :phone, :height, :weight, :smoking,
                                    :profession, :education, :civil_status, :childrens, :constitution,
                                    :eye_color, :hair_color, :visibility, :phone_v_code,
                                    :searchable, :tag_string, :nsfw, :date => [:year, :month, :day]) || {}
  end
end
