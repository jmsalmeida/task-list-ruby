require 'json'
require_relative 'task'

lista_tarefas = []
nome_arquivo = 'task-list.txt'

def menu()
  puts "Bem-vindo ao Tarefa List! Escolha uma opção no menu: \n"
  puts '[1] Inserir uma tarefa'
  puts '[2] Ver todas as tarefas'
  puts '[3] Buscar tarefas'
  puts '[4] Gerenciar tarefas'
  puts '[5] Salvar tarefas'
  puts '[6] Sair'
  puts
  print 'Opção escolhida: '
  opcao = gets.to_i
end

def adicionar_tarefa(lista)
  print 'Digite sua tarefa: '
  descricao_tarefa = gets.chomp()
  print 'Deseja adicionar um prazo para concluir a tarefa? S/N: '
  tem_prazo = gets.chomp()
  if tem_prazo == 'S'
    print 'Entre com a data limite dd-mm-aa: '
    prazo = gets.chomp()
    tarefa = Tarefa.new(descricao_tarefa, false, prazo)
    lista << tarefa
    puts
    puts tarefa
  elsif tem_prazo === 'N'
    tarefa = Tarefa.new(descricao_tarefa)
    lista << tarefa
    puts
    puts tarefa
  end
end

def ler_arquivo_tarefas(arquivo)
  tarefas = File.read(arquivo)
  if tarefas != ''
    1.times do tarefas.chop! end
    array_tarefas = '[' + tarefas + ']'
    tarefas_json = JSON.parse(array_tarefas)
    return tarefas_json
  else
    puts 'não existem tarefas'
  end
end

def listar_tarefas(lista)
  lista.each_with_index do |item, index|
    puts "##{index} tarefa: #{item['tarefa']} | status: #{item['status']} | prazo: #{item['prazo']}"
    ++index
  end
end

def buscar_tarefas(tarefas)
  print 'Digite a sua busca: '
  busca = gets.chomp()
  elementos_encontrados = []
  tarefas.each do |item|
    if item['tarefa'] == busca
      elementos_encontrados << item['tarefa']
      puts elementos_encontrados
    end
  end
  if elementos_encontrados == []
    puts 'Tarefa não encontrada!'
  end
end

def gerenciar_tarefas(arquivo)
  if File.file?(arquivo)
    puts 'Lista de tarefas'
    tarefas = ler_arquivo_tarefas(arquivo)
    listar_tarefas(tarefas)
    print 'Selecione uma tarefa: '
    tarefa_selecionada = gets.to_i
    system('clear')
    puts "tarefa: #{tarefas[tarefa_selecionada]['tarefa']}"
    puts "status: #{tarefas[tarefa_selecionada]['status']}"
    print 'aperte [1] para concluir a tarefa ou [0] para voltar: '
    concluir_tarefa = gets.to_i
    if concluir_tarefa == 1 
      tarefas[tarefa_selecionada] = {"tarefa"=>tarefas[tarefa_selecionada]['tarefa'], "status"=>'Feita'}
      File.open(arquivo, 'w') do |file|
        puts 'Escrevendo arquivo...'
        tarefas.each do |item|
          file << "{\"tarefa\":\"#{item['tarefa']}\", \"status\":\"#{item['status']}\"\},"
        end
      end
    elsif concluir_tarefa == 0
      system('clear')
      menu()
    end
  else
    puts 'Nã existem tarefas cadastradas!'
  end
end

def salvar_tarefas(arquivo, lista)
  if File.file?(arquivo)
    texto_arquivo = File.read(arquivo)
    File.open(arquivo, 'w') do |file|
      file << texto_arquivo
      puts 'Escrevendo arquivo...'
      lista.each do |tarefa|
        file << "\{\"tarefa\":\"#{tarefa.descricao}\",\"status\":\"#{tarefa.status_texto}\",\"prazo\":\"#{tarefa.prazo}\"\},"
      end
    end
  else
    File.open(arquivo, 'w') do |file|
      puts 'Criando Arquivo'
      puts 'Escrevendo arquivo...'
      lista.each do |tarefa|
        file << "\{\"tarefa\":\"#{tarefa.descricao}\",\"status\":\"#{tarefa.status_texto}\",\"prazo\":\"#{tarefa.prazo}\"\},"
      end
    end
  end
end

opcao = menu()

while opcao != 6 do
  # Voltar o menu
  if opcao == 0
    opcao = menu()
    # Adicionar tarefa
  elsif opcao == 1
    adicionar_tarefa(lista_tarefas)
    opcao = 0
    print 'aperte enter para continuar'
    gets
    system('clear')
    # Listar tarefas
  elsif opcao == 2
    if File.file?(nome_arquivo)
      tarefas = ler_arquivo_tarefas(nome_arquivo)
      puts 'Lista de tarefas: '
      listar_tarefas(tarefas)
    else
      puts 'Não existe lista de compras insira e salve os seus itens!'
    end
    opcao = 0
    print 'aperte enter para continuar'
    gets
    system('clear')
    # Buscar tarefas
  elsif opcao == 3
    lista = ler_arquivo_tarefas(nome_arquivo)
    buscar_tarefas(lista)
    opcao = 0
    print 'aperte enter para continuar'
    gets
    system('clear')
    # Gerenciar tarefas
  elsif opcao == 4
    gerenciar_tarefas(nome_arquivo)
    opcao = 0
    print 'aperte enter para continuar'
    gets
    system('clear')
    # Salvar tarefas
  elsif opcao == 5
    salvar_tarefas(nome_arquivo, lista_tarefas)
    opcao = 0
    print 'aperte enter para continuar'
    gets
    system('clear')
  else
    puts
    puts 'Opção inválida'
    opcao = 0
    print 'aperte enter para continuar'
    gets
    system('clear')
  end
end
