# Ansible

Gira su un **Control Node** e si collega via SSH ai **Managed Nodes** eseguendovi dei task definiti un un Playbook

La gestione dei Managed Nodes è agevolabile creano degli Inventory per raggrupparli

I **Modules** (raggruppati in **collections**) raggruppano tutte le info utili per un sottosistema

# Integrazione con Vagrant

```Vagrantfile
Vagrant.configure("2") do|config|
#
# Run Ansible from the Vagrant Host
#
   config.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook.yml" # deve stare nella stessa directory
   end
end
```

# Task principali:
## Creazione gruppo
```yml
    - name: Create group jhond
      ansible.builtin.group:
        name: jhond
```

## Creazione utente con password, home e scadenza
```yml
    - name: Create user jhond with password, home, and expiration
      ansible.builtin.user:
        name: jhond
        password: "{{ 'password' | password_hash('sha512') }}"
        shell: /bin/bash
        groups: jhond
        create_home: true
        expires: "{{ (ansible_date_time.epoch | int + (180 * 24 * 60 * 60)) }}"  # 180 giorni
```

## Chiave ssh per login senza password
```yml
    - name: (Opzionale) Copiare la chiave pubblica SSH per login senza password
      ansible.posix.authorized_key:
        user: jhond
        state: present
        key: "{{ lookup('file', '~/.ssh/id_rsa_ansible.pub') }}"

```

n.b.
Le chiavi si generano con
```bash
ssh-keygen -t rsa -b 2048 -f id_rsa_ansible
```

La chiave pubblica deve essere copiata in files/id_rsa_ansible.pub

# Struttura

