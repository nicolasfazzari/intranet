class IndicatorsController < ApplicationController
	before_filter :authenticate_user!, only: [:index,:show]
	def index
		@indicators = Indicator.where('user_id LIKE ? or public LIKE ?', current_user, true).order(:position)

		if params[:category].blank?
			@indicators = Indicator.where('user_id LIKE ? or public LIKE ?', current_user, true).order(:position)
		else
			@category_id=Category.find_by(name: params[:category]).id
			@indicators = Indicator.where('user_id LIKE ? and category_id LIKE ? or public LIKE ?', current_user, @category_id, true).order(:position)
		end

		@kpis = Kpi.all
		@charts=[]
		@indicators.each do |indicator|
			
			@chart = LazyHighCharts::HighChart.new('graph') do |f|
					  
					  	serie = (indicator.data.split("\n"))
					  	x = serie.first.split(',').map(&:to_s)
					  
					  	serie.drop(1).each do |serie|
					  		tampon = serie.split('|').first
					  		data= tampon.split(',').map(&:to_f).drop(1)
					  		name= serie.split(',').map(&:to_s).first


					  		options = serie.split('|').last
					  		option = options.split(',').map(&:to_s)
					  	
						  		graph = indicator.graph.split('_').map(&:to_s).last
						  			
						  			if (name.upcase=='OBJECTIF' || name.upcase=='BUDGET')
						  				puts f.series(type: 'line', name: name , yAxis: 0, data: data, color: '#ff5050')
						  			else

							  			if option.any? { |e| e.include? 'type'}
							  				puts f.series(name: name, yAxis: 0, data: data, type: option.find{ |str| str.include?('type')}.split(':').map(&:to_s).last) 
							  			else

								  			if option.any? { |e| e.include? 'stack'}
								  				puts f.series(name: name, yAxis: 0, data: data, stack: option.find{ |str| str.include?('stack')}.split(':').map(&:to_s).last) 
								  			else

									  			if option.any? { |e| e.include? 'stack'} && option.any? { |e| e.include? 'type'}
									  				puts f.series(name: name, yAxis: 0, data: data, stack: option.find{ |str| str.include?('stack')}.split(':').map(&:to_s).last, type: option.find{ |str| str.include?('type')}.split(':').map(&:to_s).last) 
									  			else
						  							puts f.series(name: name , yAxis: 0, data: data)
						  						end
						  					end
						  				end
						  			end
						  					
						  				
						  				
						  				

						  			
					
					  	  		
					  	end

					  	if (indicator.graph == "stacked_bar") || (indicator.graph =="stacked_column") || (indicator.graph =="stacked_area")
					  		f.plotOptions(series: {stacking: 'normal',dataLabels: {enabled: 'true',color: '#FFFFFF'}})
					  		f.yAxis [{title: {text: indicator.yaxis, margin: 70},stackLabels:{enabled: 'true', style:{fontWeight:'bold', color: 'gray'}}}]
					  	else
					  		f.plotOptions(series: {dataLabels: {enabled: 'true'}})
					  		f.yAxis [{title: {text: indicator.yaxis, margin: 70} },]
						end
					  f.title(text: indicator.name)
					  f.xAxis(categories: x)
					 

					  f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0, layout: 'horizontal')
					  f.chart({defaultSeriesType: indicator.graph.split('_').map(&:to_s).last})
			end
			
			@charts.push(instance_variable_set(:"@#{('a'..'z').to_a.shuffle.join}", @chart))
		end
		
		@documentations = Documentation.all
	end

	def sort 
	    params[:indicator].each_with_index do |id, index|
	        Indicator.where(id: id).update_all(position: index + 1)
	    end 

	    head :ok
	end 

	def new
		@indicator = current_user.indicators.build
	end

	def create
		@indicator = current_user.indicators.build(indicator_params)
		if @indicator.save
			redirect_to root_path
		else
			redirect_to root_path
		end
	end

	def show
		@indicator = Indicator.find(params[:id])

	end

	def edit
		@indicator = Indicator.find(params[:id])
		respond_to do |format|
		    format.html  #If it's a html request this line tell rails to look for new_release.html.erb in your views directory
		    format.js #If it's a js request this line tell rails to look for new_release.js.erb in your views directory
		  end
		
	end

	def update
		@indicator = Indicator.find(params[:id])

		if @indicator.update(params[:indicator].permit(:name, :data, :graph, :xaxis, :yaxis, :category_id, :public))
			redirect_to root_path
		else
			redirect_to root_path
		end
	end
	

	def destroy
		@indicator = Indicator.find(params[:id])
		@indicator.destroy
		redirect_to root_path
	end

	def must_be_admin
	    unless current_user && current_user.admin?
	      redirect_to root_path, notice: "must be admin"
	    end
  	end

	private
		def indicator_params
			params.require(:indicator).permit(:name, :data, :graph, :xaxis, :yaxis,:category_id,:public)
		end
end


