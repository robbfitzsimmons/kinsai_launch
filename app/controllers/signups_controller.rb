class SignupsController < ApplicationController
  # GET /signups
  # GET /signups.json
  def index
    @signups = Signup.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @signups }
    end
  end

  # GET /signups/1
  # GET /signups/1.json
  def show
    @signup = Signup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @signup }
    end
  end

  # GET /signups/new
  # GET /signups/new.json
  def new
    @signup = Signup.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @signup }
    end
  end

  # POST /signups
  # POST /signups.json
  def create
    @signup = Signup.new(params[:signup])

    respond_to do |format|
      if @signup.save

        h = Hominid::API.new(Settings.mailchimp_api_key, {:secure => true, :timeout => 60})
        h.list_subscribe(Settings.mailchimp_list_id, @signup.email)

        format.html { redirect_to @signup, notice: Settings.app.signup_success_notice }
        format.json { render json: @signup, status: :created, location: @signup }
      else
        format.html { render action: "new" }
        format.json { render json: @signup.errors, status: :unprocessable_entity }
      end
    end
  end
end
