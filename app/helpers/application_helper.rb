# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def m(expression)
    @math.parse expression
  end
  
  def n(number)
    number_with_precision(number, :precision => 2).sub(/0{1,2}$/, '').sub(/\.$/, '')
  end
  
end
