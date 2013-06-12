module PayloadValidators

  class CodeClimateImprovement < Base

    def validate!
      super
      raise Errors::CodeClimateImprovementAlreadyProcessed.new(payload) if improvement_already_attributed?
    end

    def improvement_already_attributed?
      Event.code_quality_improvements.with_key_and_value('id', payload.id).present?
    end

  end

end