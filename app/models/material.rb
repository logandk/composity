require 'material_data'

class Material < ActiveRecord::Base
  
  before_save :check_volume_factor
  
  validates_presence_of :symbol
  validates_presence_of :name
  
  has_many :layers, :order => :position
  
  serialize :data
  
  def stiffness
    if data.mechanical_properties == 'isotrope'
      q = {
        11 => (data.e_module / (1 - data.poisson_module ** 2)) * 1000,
        12 => ((data.e_module * data.poisson_module) / (1 - data.poisson_module ** 2)) * 1000,
        16 => 0,
        26 => 0,
        66 => (data.e_module / (2 * (1 + data.poisson_module))) * 1000
      }
      
      q[22] = q[11]
      
      Matrix[
        [q[11], q[12], q[16]],
        [q[12], q[22], q[26]],
        [q[16], q[26], q[66]]
      ]
    elsif data.mechanical_properties == 'stiffness'
      q = {
        11 => data.stiffness_q11,
        12 => data.stiffness_q12,
        22 => data.stiffness_q22,
        16 => data.stiffness_q16,
        26 => data.stiffness_q26,
        66 => data.stiffness_q66
      }
      
      Matrix[
        [q[11], q[12], q[16]],
        [q[12], q[22], q[26]],
        [q[16], q[26], q[66]]
      ]
    else
      e = mixture
      v = poisson
      g = shear_module
      
      q = {
        11 => (e[1] / (1 - (v[12] * v[21]))) * 1000,
        12 => ((v[21] * e[1]) / (1 - (v[12] * v[21]))) * 1000,
        22 => (e[2] / (1 - (v[12] * v[21]))) * 1000,
        16 => 0,
        26 => 0,
        66 => g[12] * 1000
      }
      
      Matrix[
        [q[11], q[12], q[16]],
        [q[12], q[22], q[26]],
        [q[16], q[26], q[66]]
      ]
    end
  end
  
  def mixture
    e = {
      1 => ((data.e_module_fibre * data.volume_factor_fibre) + (data.e_module_matrix * data.volume_factor_matrix)),
      2 => ((data.e_module_fibre * data.e_module_matrix) / ((data.volume_factor_fibre * data.e_module_matrix) + (data.volume_factor_matrix * data.e_module_fibre)))
    }
  end
  
  def poisson
    v = {
      12 => ((data.volume_factor_fibre * data.poisson_module_fibre) + (data.volume_factor_matrix * data.poisson_module_matrix))
    }
    
    v[21] = ((v[12] / mixture[1]) * mixture[2])
    
    v
  end
  
  def shear_module
    g = {
      :f => (data.e_module_fibre / (2 * (1 + data.poisson_module_fibre))),
      :m => (data.e_module_matrix / (2 * (1 + data.poisson_module_matrix)))
    }
    
    g[12] = ((g[:f] * g[:m]) / ((data.volume_factor_matrix * g[:f]) + (data.volume_factor_fibre * g[:m])))
    
    g
  end
  
  private
    def check_volume_factor
      if data.mechanical_properties == 'anisotrope'
        if data.volume_factor_fibre > 0
          data.volume_factor_matrix = 1 - data.volume_factor_fibre
        else
          data.volume_factor_fibre = 1 - data.volume_factor_matrix
        end
      end
    end
  
end
