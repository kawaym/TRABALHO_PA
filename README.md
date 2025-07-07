# 🎓 DegreeSystem Smart Contract

O `DegreeSystem` é um contrato inteligente escrito em Solidity para gerenciar o ciclo de vida acadêmico de estudantes e professores, incluindo registro, matrícula em disciplinas, e atribuição de notas (graus). Ele simula um sistema de graduação em blockchain com foco em transparência e imutabilidade.

## ✨ Funcionalidades

- Registro de alunos e professores
- Registro de cursos e turmas (classes)
- Matrícula de alunos em turmas
- Atribuição e alteração de notas (graus)
- Consulta de notas individuais ou por turma

## 📁 Estrutura do Projeto

```bash
.
├── contracts/
│   └── DegreeSystem.sol          # Contrato principal
├── test/
│   └── DegreeSystemTest.js       # Testes unitários com Hardhat
├── scripts/
│   └── deploy.js                 # Script de deploy na blockchain
├── .github/
│   └── workflows/
│       └── ci-deploy.yml         # Pipeline CI/CD no GitHub Actions
├── .env                          # Variáveis de ambiente (INFURA, PRIVATE_KEY)
├── hardhat.config.js             # Configuração da rede e Hardhat
├── package.json
└── README.md
````

## 🚀 Instalação

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/seu-repo.git
cd seu-repo

# Instale as dependências
npm install
```

## ⚙️ Configuração

Crie um arquivo `.env` com as seguintes variáveis:

```env
INFURA_API_KEY=your_infura_project_id
PRIVATE_KEY=your_wallet_private_key_without_0x
```

> ⚠️ Nunca compartilhe ou version controle sua PRIVATE\_KEY.

## 🧪 Testes Locais

O projeto utiliza [Hardhat](https://hardhat.org/) e [Chai](https://www.chaijs.com/) para testes.

```bash
npx hardhat test
```

Saída esperada:

```
  DegreeSystem
    ✔ should enroll a student
    ✔ should assign and alter degree
    ✔ should list all degrees for all enrolled students in a class
```

## 📦 Deploy

Deploy para a rede Sepolia (ou outra) usando Hardhat:

```bash
npx hardhat run scripts/deploy.js --network sepolia
```

O endereço do contrato será exibido no console:

```
DegreeSystem deployed to: 0x1234...abcd
```

## 🛠️ CI/CD com GitHub Actions

A pipeline automática realiza:

* Instalação de dependências
* Execução de testes
* Deploy para a rede Sepolia se os testes passarem

Arquivo: `.github/workflows/ci-deploy.yml`

```yaml
on:
  push:
    branches: [main]
```

### 🔐 Secrets necessários no GitHub

Acesse `Settings > Secrets and variables > Actions` e adicione:

* `INFURA_API_KEY`: sua chave Infura
* `PRIVATE_KEY`: chave privada da carteira com ETH de testes

---

## 🧱 Stack

* **Solidity 0.8.x**
* **Hardhat**
* **Ethers.js v6**
* **Chai**
* **Infura** (para RPC da rede)
* **GitHub Actions** (CI/CD)

---

## 📝 Licença

Este projeto está licenciado sob os termos da **MIT License**.