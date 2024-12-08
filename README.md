# Konfiguracja Self-Hosted Agent dla Azure DevOps

Są sytuacje, kiedy agenty Azure DevOps nie są dostępne, brakuje im oprogramowania lub nie możemy z nich korzystać (np. ograniczenia sieciowe, bezpieczeństwa itd.).

W takich przypadkach można skonfigurować Self-Hosted Agent na maszynie wirtualnej.
W praktyce oznacza to zbudowanie maszyny wirtualnej z odpowiednim oprogramowaniem oraz skonfigurowanie agenta Azure DevOps.
Po takiej operacji maszyna wirtualna będzie mogła być używana do uruchamiania Pipelines w Azure DevOps.

## Wymagania wstępne

- Skonfigurowany projekt w Azure DevOps

## Przygotowanie infrastruktury

Zrób klon repozytorium:

```bash
git clone https://github.com/wguzik/ado-runner.git
```

Wejdź do katalogu z projektem i infrastrukturą:

```bash
cd ado-runner/infra/
```

Przygotuj plik z zmiennymi:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Wprowadź wartości dla zmiennych w pliku `terraform.tfvars`

Wystarczy wartość `owner`, inicjały wystarczą.

```bash
code .
```

Zapisz zmiany i wyjdź.

Wdróż infrastrukturę:

```bash
terraform validate
terraform init
terraform apply
```

Zapisz zewnętrzny adres IP maszyny wirtualnej oraz znajdź hasło do maszyny wirtualnej w Key Vault.

> Ważne! Ta maszyna wirtualna nie ma żadnych zabezpieczeń, jest dostępna z publicznego internetu. Jest to uproszczenie, które zostało zastosowane w celach demonstracyjnych.

## Konfiguracja agenta

### Detale agentów

Przejdź do Azure DevOps -> Project Settings -> Agent pools > Default (zakładka `Agent`) > "New agent" (zakładka `Linux`)

żeby podejrzeć co jest potrzebne do konfiguracji agenta. 

### 1. Przygotowanie Personal Access Token (PAT)
1. Przejdź do Azure DevOps -> User Settings -> Personal Access Tokens
2. Utwórz nowy token z uprawnieniami:
   - Agent Pools (Read & Manage)
   - Deployment Groups (Read & Manage)

3. Zapisz na boku wartość tokenu, bo ponieważ jeżeli zamkniesz okno, nie będzie można go ponownie wyświetlić.

[![Tworzenie PAT](https://img.youtube.com/vi/8b0oPzN-dmw/0.jpg)](https://www.youtube.com/watch?v=8b0oPzN-dmw)

### 2. Konfiguracja agenta na maszynie wirtualnej

Połącz się z maszyną wirtualną

Hasło znajdziesz w Key Vault

```bash
ssh adminuser@<vm-ip>

# na pytanie o rodzaj uwierzytelniania wpisz "yes", a potem wklej hasło
```

Utwórz katalog roboczy

```bash
mkdir myagent && cd myagent
```

Pobierz agenta

```bash
wget https://vstsagentpackage.azureedge.net/agent/3.248.0/vsts-agent-linux-x64-3.248.0.tar.gz
tar zxvf vsts-agent-linux-x64-3.248.0.tar.gz
```

Zainstaluj aplikacje niezbędne do działania agenta

```
sudo ./bin/installdependencies.sh
```
Skonfiguruj agenta

```bash
./config.sh

Enter (Y/N) Accept the Team Explorer Everywhere license agreement now? (press enter for N) > Y

Enter server URL: https://dev.azure.com/<nazwa organizacji>

# np. https://dev.azure.com/wojciechguzik0366/

Enter authentication type (press enter for PAT) > [enter]

# w kolejnym kroku wklej token

# Poniższe kroki z domyślnymi wartościami

Enter agent pool (press enter for default) > [enter]

Enter agent name (press enter for ado-wg-vm) > [enter]

Enter work folder (press enter for _work) > [enter]
```

Uruchom usługę

```bash
sudo ./svc.sh install

sudo ./svc.sh start

# sprawdź status usługi
sudo ./svc.sh status
```

## Konfiguracja pipeline

Aby skorzystać z agenta, musisz dodać go wskazać w pipeline:

```yaml
pool:
  name: 'default'
```

Po uruchomieniu swojego pipeline, musisz przyznać uprawnienia.

Nawiguj do "Pipelines" -> znajdź pipeline:

<img src='./media/widok-pipeline.png' width=360/>

kliknij "View"

<img src='./media/widok-pipeline-przyznanie-uprawnien.jpeg' width=360/>

wybierz "Permit".

Przykład działającej konfiguracji:

[![Demo](https://img.youtube.com/vi/DM6CNTxY6pM/0.jpg)](https://www.youtube.com/watch?v=DM6CNTxY6pM)

## Usuń zasoby

Jeżeli nie planujesz dalszego korzystania z agenta, usuń zasoby w Terraform.

```bash
terraform destroy
```

Możesz również usunąć maszynę wirtualną w Azure Portal.

Usuń agenta w Azure DevOps -> Project Settings -> Agent pools -> Default -> "Edit" -> "Delete".

W razie potrzeby stwórz nowego agenta.
