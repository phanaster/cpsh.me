class CouponsController < ApplicationController
  # GET /coupons/1
  # GET /coupons/1.json
  def show
    if params.has_key?(:url_token)
      #@coupon = Coupon.find_by_url_token!(params[:url_token])
      @coupon= Coupon.find_by(url_token: params[:url_token])   
      
    else
      redirect_to :root
      return
    end
    
    @views_remaining = 0
    @days_remaining = 0
    
    # FIXME: This should be changed to a database enforced default value in case of nil
    @coupon.expire_after_days = 1 unless @coupon.expire_after_days
    @coupon.expire_after_views = 2 unless @coupon.expire_after_views
    
    #dates = @coupon.created_at

    #dates.to_datetime

    @days_old = (Time.now.to_datetime - @coupon.created_at.to_datetime).to_i
    @days_remaining = @coupon.expire_after_days - @days_old
    unless @coupon.expired
      # This coupon hasn't expired yet.
      if (@days_old > @coupon.expire_after_days) or (@coupon.viewcount > @coupon.expire_after_views)
        # This coupon has hit max age or max views - expire it
        @coupon.expired = true
        @coupon.code = nil
        @coupon.save

        redirect_to '/expired'
        return
      else
        @views_remaining = @coupon.expire_after_views - @coupon.viewcount
        
        if (@views_remaining > 100)
	@enough_views = true
	end
        
        
        @code = @coupon.code
	@desc = @coupon.description
        @link = @coupon.link
      end
    else
      # This coupon is expired      
    end
    
    @views_remaining = 0 if @views_remaining < 0
    @days_remaining = 0  if @days_remaining  < 0
    
    if @coupon.viewcount == 0
      @first_view = true
    end
    
    #@view = View.new
    #@view.coupon_id = @coupon.id
    #@view.ip = request.env["HTTP_X_FORWARDED_FOR"].nil? ? request.env["REMOTE_ADDR"] : request.env["HTTP_X_FORWARDED_FOR"]
    #@view.user_agent = request.env["HTTP_USER_AGENT"]
    #@view.referrer = request.env["HTTP_REFERER"]
    #@view.successful = @coupon.expired ? false : true
    #@view.save
    
    #@views << @view
    @coupon.viewcount += 1
    @coupon.save

    #expires_now()

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @coupon }
    end
  end

  # GET /coupons/expired
  def expired
  end


  # GET /coupons/impressum
  def impressum
  end

  # GET /coupons/new
  # GET /coupons/new.json
  def new
    @coupon = Coupon.new

    expires_in 3.hours, :public => true, 'max-stale' => 0

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /coupons
  # POST /coupons.json
  def create
    #if params[:coupon][:code].blank? or params[:coupon][:code] == PAYLOAD_INITIAL_TEXT
      #redirect_to '/'
      #return
    #end

    @coupon = Coupon.new()
    
    @coupon.expire_after_days = params[:coupon][:expire_after_days]
    @coupon.expire_after_views = params[:coupon][:expire_after_views]
    
    # Check ranges - no max currently
    @coupon.expire_after_days = 7 if @coupon.expire_after_days.blank?
    @coupon.expire_after_views = 99999 if @coupon.expire_after_views.blank?
    
    @coupon.url_token = rand(36**16).to_s(36)
    
    
    
    
    @coupon.code = params[:coupon][:code]
    @coupon.description = params[:coupon][:description]
    @coupon.link = params[:coupon][:link]
    
    respond_to do |format|
      if @coupon.save
        format.html { redirect_to "/c/#{@coupon.url_token}", :notice => "The coupon has been pushed." }
        format.json { render :json => @coupon, :status => :created}
      else
        format.html { render :action => "new" }
        format.json { render :json => @coupon.errors, :status => :unprocessable_entity }
      end
    end
  end
end
