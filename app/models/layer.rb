class Layer < ActiveRecord::Base
  
  belongs_to :calculation
  belongs_to :material
  
  def stiffness
    if material.data.mechanical_properties == 'isotrope' or angle == 0.0
      q = material.stiffness
    else
      rangle = Math.to_radian(angle)
      
      q = {
        11 => material.stiffness[0,0] * (Math.cos(rangle) ** 4) + 2 * (material.stiffness[0,1] + (2 * material.stiffness[2,2])) * (Math.sin(rangle) ** 2) * (Math.cos(rangle) ** 2) + material.stiffness[1,1] * (Math.sin(rangle) ** 4),
        12 => (material.stiffness[0,0] + material.stiffness[1,1] - (4 * material.stiffness[2,2])) * (Math.sin(rangle) ** 2) * (Math.cos(rangle) ** 2) + material.stiffness[0,1] * ((Math.sin(rangle) ** 4) + (Math.cos(rangle) ** 4)),
        22 => material.stiffness[0,0] * (Math.sin(rangle) ** 4) + 2 * (material.stiffness[0,1] + (2 * material.stiffness[2,2])) * (Math.sin(rangle) ** 2) * (Math.cos(rangle) ** 2) + material.stiffness[1,1] * (Math.cos(rangle) ** 4),
        16 => (material.stiffness[0,0] - material.stiffness[0,1] - (2 * material.stiffness[2,2])) * (Math.sin(rangle)) * (Math.cos(rangle) ** 3) + (material.stiffness[0,1] - material.stiffness[1,1] + (2 * material.stiffness[2,2])) * (Math.sin(rangle) ** 3) * (Math.cos(rangle)),
        26 => (material.stiffness[0,0] - material.stiffness[0,1] - (2 * material.stiffness[2,2])) * (Math.sin(rangle) ** 3) * (Math.cos(rangle)) + (material.stiffness[0,1] - material.stiffness[1,1] + (2 * material.stiffness[2,2])) * (Math.sin(rangle)) * (Math.cos(rangle) ** 3),
        66 => (material.stiffness[0,0] + material.stiffness[1,1] - (2 * material.stiffness[0,1]) - (2 * material.stiffness[2,2])) * (Math.sin(rangle) ** 2) * (Math.cos(rangle) ** 2) + material.stiffness[2,2] * ((Math.sin(rangle) ** 4) + (Math.cos(rangle) ** 4))
      }
    
      q = Matrix[
        [q[11], q[12], q[16]],
        [q[12], q[22], q[26]],
        [q[16], q[26], q[66]]
      ]
    end
    
    q
  end
  
end
