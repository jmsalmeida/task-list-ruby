class Tarefa
  attr_accessor :descricao, :status, :prazo

  def initialize(descricao, status=false, prazo="indeterminado")
    @descricao = descricao
    @status = status
    @prazo = prazo
  end

  def to_s
    "tarefa cadastrada: #{descricao}, status: #{status_texto}, prazo: #{prazo}"
  end

  def status_texto
    if status
      'Feita'
    else
      'Não feita'
    end
  end
end