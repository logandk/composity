module MaterialsHelper
  
  def var(name)
    n(@material.data.send(name))
  end
  
end
