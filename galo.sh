#!/bin/bash

# Função para inicializar o tabuleiro
initialize_board() {
    board=("1" "2" "3" "4" "5" "6" "7" "8" "9")
}

# Função para exibir o tabuleiro
display_board() {
    echo " ${board[0]} | ${board[1]} | ${board[2]} "
    echo "-----------"
    echo " ${board[3]} | ${board[4]} | ${board[5]} "
    echo "-----------"
    echo " ${board[6]} | ${board[7]} | ${board[8]} "
}

# Função para verificar se há um vencedor
check_winner() {
    local winner=false
    local lines=("0 1 2" "3 4 5" "6 7 8" "0 3 6" "1 4 7" "2 5 8" "0 4 8" "2 4 6")

    for line in "${lines[@]}"; do
        local cells=($line)
        if [ "${board[${cells[0]}]}" == "${board[${cells[1]}]}" ] && [ "${board[${cells[1]}]}" == "${board[${cells[2]}]}" ]; then
            winner=true
            break
        fi
    done

    echo "$winner"
}

# Função para verificar se o tabuleiro está cheio (empate)
check_tie() {
    local tie=true
    for cell in "${board[@]}"; do
        if [ "$cell" != "X" ] && [ "$cell" != "O" ]; then
            tie=false
            break
        fi
    done

    echo "$tie"
}

# Função para a jogada do jogador contra a máquina
player_vs_machine() {
    local player="X"
    local move

    initialize_board

    while true; do
        echo ;
        echo "-----------";
        echo ;
        display_board
        echo "";
        echo "-----------";
        echo "";

        if [ "$player" == "X" ]; then
            echo "É a vez do jogador $player. Escolha um número (1-9): "
            read move

            if [[ ! "$move" =~ ^[1-9]$ ]]; then
                echo "Entrada inválida. Escolha um número de 1 a 9."
                continue
            fi
        else
            # Lógica para a jogada da máquina (gera um número aleatório não escolhido)
            move=$((1 + RANDOM % 9))
        fi

        index=$((move - 1))

        if [ "${board[index]}" == "X" ] || [ "${board[index]}" == "O" ]; then
            echo "Essa posição já foi escolhida. Escolha outra."
        else
            board[index]="$player"

            if [ "$(check_winner)" == "true" ]; then
                display_board
                if [ "$player" == "X" ]; then
                    echo "Parabéns! Você venceu!"
                else
                    echo "A máquina venceu. Tente novamente!"
                fi
                break
            elif [ "$(check_tie)" == "true" ]; then
                display_board
                echo "O jogo terminou em empate!"
                break
            else
                # Alternar jogadores corretamente
                if [ "$player" == "X" ]; then
                    player="O"
                else
                    player="X"
                fi
            fi
        fi
    done
}

# Função principal do jogo
play_game() {
    echo "Bem-vindo ao Jogo do Galo!"
    echo "Escolha uma opção:"
    echo "1. Jogar multiplayer"
    echo "2. Jogar contra a máquina"
    read option

    case $option in
        1)
            play_multiplayer_game
            ;;
        2)
            player_vs_machine
            ;;
        *)
            echo "Opção inválida. Saindo do jogo."
            ;;
    esac
}

# Função para o jogo multiplayer (código anterior)
play_multiplayer_game() {
    local player="X"
    local move

    initialize_board

    while true; do
        display_board

        echo "É a vez do jogador $player. Escolha um número (1-9): "
        read move

        if [[ ! "$move" =~ ^[1-9]$ ]]; then
            echo "Entrada inválida. Escolha um número de 1 a 9."
            continue
        fi

        index=$((move - 1))

        if [ "${board[index]}" == "X" ] || [ "${board[index]}" == "O" ]; then
            echo "Essa posição já foi escolhida. Escolha outra."
        else
            board[index]="$player"

            if [ "$(check_winner)" == "true" ]; then
                display_board
                echo "Parabéns! O jogador $player venceu!"
                break
            elif [ "$(check_tie)" == "true" ]; then
                display_board
                echo "O jogo terminou em empate!"
                break
            else
                # Alternar jogadores corretamente
                if [ "$player" == "X" ]; then
                    player="O"
                else
                    player="X"
                fi
            fi
        fi
    done
}

# Iniciar o jogo
play_game
