class MaterialData
  attr_accessor :mechanical_properties
  attr_float :e_module, :poisson_module, :e_module_fibre, :e_module_matrix, :poisson_module_fibre, :poisson_module_matrix, :volume_factor_fibre, :volume_factor_matrix, :stiffness_q11, :stiffness_q12, :stiffness_q22, :stiffness_q16, :stiffness_q26, :stiffness_q66
  
  def initialize(h={})
    h.each do |k, v|
      respond_to?(:"#{k}=") ? send(:"#{k}=", v) : raise(UnknownAttributeError, "unknown attribute: #{k}")
    end
  end
end