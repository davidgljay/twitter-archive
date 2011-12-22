class HashtagsController < ApplicationController
  # GET /hashtags
  # GET /hashtags.xml
  def index
    @hashtags = Hashtag.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @hashtags }
    end
  end

  def tracking
   @hashtag = Hashtag.new
   @hashtags = Hashtag.where(:archive => true)
   @related_big = {}
   @hashtags.each do |hash|
      @related_big[hash] = hash.bigger_hashes.first(5)
   end
   @related_small = {}
   @hashtags.each do |hash|
      @related_small[hash] = hash.smaller_hashes.first(5)
   end

   respond_to do |format|
     format.html #tracking.html.erb
   end
  end

  # GET /hashtags/1
  # GET /hashtags/1.xml
  def show
    @hashtag = Hashtag.find(params[:id])
    @related_hashtags = @hashtag.related_hashtag_cloud
    if @hashtag.tweets.count > 20
       @tweets = @hashtag.tweets.reverse.drop(@hashtag.tweets.count - 20).reverse!
       else
       @tweets = @hashtag.tweets 
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @hashtag }
    end
  end

  # GET /hashtags/new
  # GET /hashtags/new.xml
  def new
    @hashtag = Hashtag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @hashtag }
    end
  end

  # GET /hashtags/1/edit
  #def edit
  #  @hashtag = Hashtag.find(params[:id])
  #end

  # POST /hashtags
  # POST /hashtags.xml
  def create
    @hashtag = Hashtag.new(params[:hashtag])
    @hashtag.archive = true
    respond_to do |format|
      if @hashtag.save
        format.html { redirect_to(@hashtag, :notice => 'Hashtag was successfully created.') }
        format.xml  { render :xml => @hashtag, :status => :created, :location => @hashtag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @hashtag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /hashtags/1
  # PUT /hashtags/1.xml
  def update
    @hashtag = Hashtag.find(params[:id])

    respond_to do |format|
      if @hashtag.update_attributes(params[:hashtag])
        format.html { redirect_to(@hashtag, :notice => 'Hashtag was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @hashtag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /hashtags/1
  # DELETE /hashtags/1.xml
  def destroy
    @hashtag = Hashtag.find(params[:id])
    @hashtag.destroy

    respond_to do |format|
      format.html { redirect_to(hashtags_url) }
      format.xml  { head :ok }
    end
  end

# require 'rubygems' if using this outside of Rails
#require 'fastercsv'

#def dump_csv
#  @users = User.find(:all, :order => "lastname ASC")
#  @outfile = "members_" + Time.now.strftime("%m-%d-%Y") + ".csv"
  
#  csv_data = FasterCSV.generate do |csv|
#    csv << ["titles"    ]
#    @users.each do |user|
#      csv << [ data      ]
#    end
#  end

#  send_data csv_data,
#    :type => 'text/csv; charset=iso-8859-1; header=present',
#    :disposition => "attachment; filename=#{@outfile}"

#  flash[:notice] = "Export complete!"
#end

              

end
