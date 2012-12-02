class UsersController < ApplicationController
	load_and_authorize_resource except:[:index, :show]
  before_filter :authenticate_user!, except: [:index, :show]

  def index
    @user = User.all
  end

  def show
  	@user = User.find(params[:id])
    @certifications = @user.professional_accomplishments.where(:accomplishment_type => "Certificate")
    @awards = @user.professional_accomplishments.where(:accomplishment_type => "Award")
  	respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def edit
  	@user = User.find(params[:id])
  end

  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'Profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

end
