class Module
  def attr_float(*symbols)
    symbols.each do |symbol|
      class_eval "def #{symbol}; @#{symbol}.to_f; end"
      class_eval "def #{symbol}=(value); @#{symbol}=value.to_f; end"
    end
  end
end

module Math
  def self.to_radian(angle)
    angle * (Math::PI / 180)
  end
end