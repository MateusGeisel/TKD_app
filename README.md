# 🥋 TKD Manager

Aplicação mobile desenvolvida em **Flutter** voltada para a gestão de atletas e controlo de combates de **Taekwondo (TKD)**.

---

## 🚀 Funcionalidades

- 🥋 **Registo de Lutadores:** Cadastro e gestão em memória de atletas com nome, idade, academia/equipa e graduação (faixa).
- ⏱️ **Placar Eletrónico (Scoreboard):** 
  - Registo dinâmico de pontuação oficial (+1, +2, +3, +4, +5).
  - Registo de faltas (*Gam-jeom*) com atribuição automática de ponto ao oponente.
  - Seleção de duração do *round* (1 min ou 2 min).
  - Cronómetro regressivo com alertas sonoros e sinalização visual de fim de round.
- 🎨 **Interface Responsiva & Dark Mode:** Design escuro e otimizado no estilo arena de combate.

---

## 🛠️ Tecnologias Utilizadas

- **Language:** Dart
- **Framework:** Flutter
- **State Management:** Provider / Singleton Pattern
- **Audio:** `audioplayers`

---

## 📱 Como Executar o Projeto

1. Clone este repositório:
   ```bash
   git clone [https://github.com/](https://github.com/)<MateusGeisel>/TKD_app.git

2. Aceda à pasta do projeto:
    Bash
    cd tkd-manager-flutter
3. Instale as dependências:
    Bash
    flutter pub get
4. Execute a aplicação:
    Bash
    flutter run