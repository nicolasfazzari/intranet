class IndicatorsController < ApplicationController
	before_filter :must_be_admin, only: [:new,:create,:edit,:update,:destroy]
	before_filter :authenticate_user!, only: [:index,:show]
	def index
		@indicators = Indicator.where('user_id = ? or public = ?', current_user, true).order(:position)
		if  params[:tag].blank? && params[:department].blank? 
			@indicators = Indicator.where('user_id = ? or public = ?', current_user, true).order(:position)
		elsif params[:tag] && params[:department].blank?
    		@indicators = Indicator.tagged_with(params[:tag]).where('user_id = ? or public = ?', current_user, true).order(:position)
    	else params[:department] && params[:tag].blank?
     		@department_id=Department.find_by(name: params[:department]).id
			@indicators = Indicator.where('user_id = ? and department_id = ? or public = ? and department_id = ? ', current_user, @department_id, true, @department_id).order(:position)
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
						  							if indicator.graph == "spider_line"
									  					puts f.series(name: name, data: data, pointPlacement: 'on', dataLabels: {enabled: false})
									  					puts f.yAxis [{gridLineInterpolation: 'polygon', lineWidth: 0, min: 0}]
						  								puts f.xAxis [categories: x, tickmarkPlacement: 'on', lineWidth: 0]
						  								puts f.pane [size: '80%']
						  							
						  							
									  				else
						  								puts f.series(name: name , yAxis: 0, data: data)
						  							end
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
					  	
					  
					  
					 

					 
					  if indicator.graph == "spider_line"
					  	f.chart({defaultSeriesType: indicator.graph.split('_').map(&:to_s).last, polar: 'true' })
					  	f.title(text: indicator.name)
					  	f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0, layout: 'horizontal')
					  else
					  	f.chart({defaultSeriesType: indicator.graph.split('_').map(&:to_s).last})
					  	f.title(text: indicator.name)
					  	f.xAxis(categories: x)
					    f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0, layout: 'horizontal')
					  end
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

		if @indicator.update(params[:indicator].permit(:name, :data, :graph, :yaxis,:public, :department_id, :tag_list))
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
			params.require(:indicator).permit(:name, :data, :graph, :yaxis, :public, :department_id, :tag_list)
		end
end


