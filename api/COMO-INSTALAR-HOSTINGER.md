# 🌐 Como Ativar a Telemetria e Ranking Remoto na Hostinger (unbk.com.br)

Esta pasta `api/` contém a infraestrutura pronta para que o seu script `setup.ps1` passe a computar os aplicativos mais populares **remotamente**, considerando o que **todos os outros usuários** escolherem e instalarem.

---

### 📂 Passo a Passo na Hostinger (Leva menos de 1 minuto):

1. Acesse o painel da **Hostinger** (hPanel).
2. Vá em **Sites** > Selecione `unbk.com.br` > Clique em **Gerenciador de Arquivos** (File Manager).
3. Abra a pasta `public_html`.
4. Envie ou arraste a pasta inteira `api` para dentro de `public_html/` (de modo que fique `public_html/api/`).
5. **Pronto!** 🚀

---

### 🔍 Como Testar se está Funcionando:

Abra o seu navegador e acesse:
```
https://unbk.com.br/api/vote.php
```
Ou:
```
https://unbk.com.br/api/popular.json
```
Você verá o JSON com os 24 aplicativos mais votados.

---

### ⚙️ Como Funciona nos Bastidores:

1. **Ao abrir o `setup.ps1` no computador de qualquer usuário:**
   - O script faz uma consulta ultrarrápida (timeout de 1 segundo) para `https://unbk.com.br/api/popular.json`.
   - Se a internet estiver ativa e o endpoint responder, o script carrega a lista atualizada dos softwares mais votados.
   - Caso o usuário esteja offline ou a conexão falhe, o script usa instantaneamente o catálogo padrão curado (Chrome, Steam, 7-Zip, Hydra Launcher, etc.), sem travar nem exibir nenhum erro.

2. **Ao clicar no botão `⭐ Mais Populares`:**
   - O script alterna em tempo real para exibir apenas os aplicativos mais populares entre todas as categorias, ocultando os demais para facilitar a seleção rápida. Clicando novamente, restaura a exibição completa de todos os 245 aplicativos.

3. **Ao clicar em "Instalar Selecionados":**
   - O `setup.ps1` dispara um processo em segundo plano (background job assíncrono, que leva 0ms do tempo do instalador) enviando um ping com as chaves dos programas selecionados para `https://unbk.com.br/api/vote.php`.
   - O arquivo `vote.php` na sua Hostinger incrementa os votos e recalcula o Top 25 em tempo real.
   - Nenhum dado pessoal do usuário é coletado — apenas os nomes dos softwares instalados.
