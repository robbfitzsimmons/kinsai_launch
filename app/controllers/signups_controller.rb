class SignupsController < ApplicationController
  # GET /signups
  # GET /signups.json
  def index
    redirect_to root_url

    # @signups = Signup.all

    # respond_to do |format|
    #   # format.html # index.html.erb
    #   format.html { render text: 'No list yet :)' }
    #   format.json { render json: @signups }
    # end
  end

  # GET /signups/1
  # GET /signups/1.json
  def show
    redirect_to root_url

    # @signup = Signup.find(params[:id])

    # respond_to do |format|
    #   format.html # show.html.erb
    #   # format.json { render json: @signup }
    # end
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
    @signup.status = Signup::STATUS_NEW

    respond_to do |format|
      if @signup.save

        # Handle any MailChimp errors
        begin
          h = Hominid::API.new(Settings.mailchimp.api_key, {:secure => true, :timeout => 60})
          h.list_subscribe(Settings.mailchimp.list_id, @signup.email, {}, Settings.mailchimp.email_format, Settings.mailchimp.email_double_optin)
        rescue Hominid::APIError => e
          @signup.delete # Don't save the record on error - it wasn't subscribed to the MailChimp list
          @signup.errors.add(:email, 'MailChimp API Error: ' + e.message)
        end
      end

      if @signup.errors.any?
        format.html { render action: "new" }
        format.json { render json: @signup.errors, status: :unprocessable_entity }
      else
        @signup.update_attribute(:status, Signup::STATUS_SUBSCRIBED)

        format.html { redirect_to root_url, notice: Settings.app.signup_success_notice }
        format.json { render json: @signup, status: :created, location: @signup }
      end
    end
  end
end
