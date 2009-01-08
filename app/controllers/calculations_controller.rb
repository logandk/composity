class CalculationsController < ApplicationController
  # GET /calculations
  # GET /calculations.xml
  def index
    @calculations = Calculation.find(:all, :order => :title)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @calculations }
    end
  end

  # GET /calculations/1
  # GET /calculations/1.xml
  def show
    @calculation = Calculation.find(params[:id])
    
    # Calculations
    @layers = [
      {
        :height => 2,
        :angle => 0,
        #:stifness => { :e }
      }
    ]
    
    @e_module = { #GPa
      :f => 240,
      :m => 4
    }
    
    @poisson = {
      :f => 0.3,
      :m => 0.35
    }
    
    @volume_fraction = {
      :f => 0.65,
      :m => 1 - 0.65
    }
    
    @e_mixture = {
      1 => (@e_module[:f] * @volume_fraction[:f] + @e_module[:m] * @volume_fraction[:m]),
      2 => ((@e_module[:f] * @volume_fraction[:m]) / (@volume_fraction[:m] * @e_module[:f] + @volume_fraction[:f] * @e_module[:m]))
    }
  end

  # GET /calculations/new
  # GET /calculations/new.xml
  def new
    @calculation = Calculation.new
    @calculation.layers << Layer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @calculation }
    end
  end

  # GET /calculations/1/edit
  def edit
    @calculation = Calculation.find(params[:id])
  end

  # POST /calculations
  # POST /calculations.xml
  def create
    @calculation = Calculation.new(params[:calculation])
    save_layers @calculation, params[:layers]

    respond_to do |format|
      if @calculation.save
        flash[:notice] = 'Calculation was successfully created.'
        format.html { redirect_to(@calculation) }
        format.xml  { render :xml => @calculation, :status => :created, :location => @calculation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @calculation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /calculations/1
  # PUT /calculations/1.xml
  def update
    @calculation = Calculation.find(params[:id])
    save_layers @calculation, params[:layers]

    respond_to do |format|
      if @calculation.update_attributes(params[:calculation])
        flash[:notice] = 'Calculation was successfully updated.'
        format.html { redirect_to(@calculation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @calculation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /calculations/1
  # DELETE /calculations/1.xml
  def destroy
    @calculation = Calculation.find(params[:id])
    @calculation.destroy

    respond_to do |format|
      format.html { redirect_to(calculations_url) }
      format.xml  { head :ok }
    end
  end
  
  private
    def save_layers(calculation, layers)
      calculation.layers.clear
      
      layers.each do |layer|
        calculation.layers << Layer.new(layer[1])
      end
    end
end
