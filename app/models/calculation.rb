class Calculation < ActiveRecord::Base
  
  validates_presence_of :title
  
  serialize :data
  
  has_many :layers, :order => :position, :dependent => :destroy
  
  def laminate_center
    sum = 0
    layers.each { |l| sum += l.thickness }
    sum / 2
  end
  
  def stiffness(type=:a)
    z = -laminate_center
    stiffness = nil
    
    layers.each do |l|
      result = case type
        when :a: l.stiffness * ((z + l.thickness) - z)
        when :b: (l.stiffness * (((z + l.thickness) ** 2) - (z ** 2))) * (1.0 / 2.0)
        when :d: (l.stiffness * (((z + l.thickness) ** 3) - (z ** 3))) * (1.0 / 3.0)
      end
      
      if stiffness.nil?
        stiffness = result
      else
        stiffness += result
      end
      
      z += l.thickness
    end
    
    stiffness
  end
  
end
