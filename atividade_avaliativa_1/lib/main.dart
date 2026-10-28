import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaLocadora(),
    );
  }
}

class TelaLocadora extends StatefulWidget {
  const TelaLocadora({super.key});

  @override
  State<TelaLocadora> createState() => _TelaLocadoraState();
}

class _TelaLocadoraState extends State<TelaLocadora> {
  String veiculoSelecionado = "Econômico";
  bool seguroCompleto = false;
  bool gps = false;
  bool motoristaAdicional = false;
  double quantidadeDias = 1;

  void mudarVeiculo(String valor) {
    setState(() {
      veiculoSelecionado = valor;
    });
  }

  void mudarSeguro(bool valor) {
    setState(() {
      seguroCompleto = valor;
    });
  }

  void mudarGps(bool valor) {
    setState(() {
      gps = valor;
    });
  }

  void mudarMotorista(bool valor) {
    setState(() {
      motoristaAdicional = valor;
    });
  }

  void mudarDias(double valor) {
    setState(() {
      quantidadeDias = valor;
    });
  }

  double calcularValorDiario() {
    double valor = 120;

    if (veiculoSelecionado == "SUV") {
      valor = 180;
    } else if (veiculoSelecionado == "Luxo") {
      valor = 300;
    }

    if (seguroCompleto == true) {
      valor = valor + 40;
    }

    if (gps == true) {
      valor = valor + 15;
    }

    return valor;
  }

  double calcularValorBruto() {
    double valor = calcularValorDiario() * quantidadeDias;

    if (motoristaAdicional == true) {
      valor = valor + 100;
    }

    return valor;
  }

  double calcularDesconto() {
    double desconto = 0;

    if (quantidadeDias >= 15) {
      desconto = 0.10;
    } else if (quantidadeDias >= 7) {
      desconto = 0.05;
    }

    return calcularValorBruto() * desconto;
  }

  double calcularValorFinal() {
    return calcularValorBruto() - calcularDesconto();
  }

  String mostrarDinheiro(double valor) {
    return "R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}";
  }

  String mostrarDescontoPercentual() {
    if (quantidadeDias >= 15) {
      return "10%";
    } else if (quantidadeDias >= 7) {
      return "5%";
    }

    return "0%";
  }

  void finalizarReserva() {
    showDialog(
      context: context,
      builder: (contextoDialogo) {
        return AlertDialog(
          title: const Text("Resumo da Reserva"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Veículo: $veiculoSelecionado"),
                Text("Dias: ${quantidadeDias.toInt()}"),
                Text("Seguro completo: ${seguroCompleto ? 'Sim' : 'Não'}"),
                Text("GPS: ${gps ? 'Sim' : 'Não'}"),
                Text(
                  "Motorista adicional: "
                  "${motoristaAdicional ? 'Sim' : 'Não'}",
                ),
                const Divider(),
                Text("Valor bruto: ${mostrarDinheiro(calcularValorBruto())}"),
                Text(
                  "Desconto (${mostrarDescontoPercentual()}): "
                  "${mostrarDinheiro(calcularDesconto())}",
                ),
                const SizedBox(height: 8),
                Text(
                  "Valor final: ${mostrarDinheiro(calcularValorFinal())}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(contextoDialogo);
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(contextoDialogo);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Reserva realizada com sucesso!"),
                  ),
                );
              },
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: const Color(0xFFFBF7FF),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Locadora de Carros",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text("Escolha o veículo", style: TextStyle(fontWeight: FontWeight.bold)),

                    const SizedBox(height: 8),

                    // Substituído o SegmentedButton por um Dropdown simples de iniciante
                    DropdownButton<String>(
                      value: veiculoSelecionado,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: "Econômico", child: Text("Econômico (R\$ 120/dia)")),
                        DropdownMenuItem(value: "SUV", child: Text("SUV (R\$ 180/dia)")),
                        DropdownMenuItem(value: "Luxo", child: Text("Luxo (R\$ 300/dia)")),
                      ],
                      onChanged: (novoValor) {
                        mudarVeiculo(novoValor!);
                      },
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "Opcionais",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: Colors.deepPurple,
                      title: const Text("Seguro completo (+ R\$ 40/dia)"),
                      value: seguroCompleto,
                      onChanged: (valor) {
                        mudarSeguro(valor ?? false);
                      },
                    ),

                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: Colors.deepPurple,
                      title: const Text("GPS (+ R\$ 15/dia)"),
                      value: gps,
                      onChanged: (valor) {
                        mudarGps(valor ?? false);
                      },
                    ),

                    Row(
                      children: [
                        const Expanded(
                          child: Text("Motorista adicional (+ R\$ 100 fixos)"),
                        ),
                        Switch(
                          activeColor: Colors.deepPurple,
                          value: motoristaAdicional,
                          onChanged: (valor) {
                            mudarMotorista(valor);
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text("Quantidade de dias: ${quantidadeDias.toInt()}", style: const TextStyle(fontWeight: FontWeight.bold)),

                    Slider(
                      min: 1,
                      max: 30,
                      divisions: 29,
                      activeColor: Colors.deepPurple,
                      value: quantidadeDias,
                      onChanged: (valor) {
                        mudarDias(valor);
                      },
                    ),

                    const Divider(),

                    const Text(
                      "Resumo da Locação",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text("Veículo: $veiculoSelecionado"),
                    Text("Dias: ${quantidadeDias.toInt()}"),
                    Text("Seguro: ${seguroCompleto ? 'Sim' : 'Não'}"),
                    Text("GPS: ${gps ? 'Sim' : 'Não'}"),
                    Text(
                      "Motorista adicional: "
                      "${motoristaAdicional ? 'Sim' : 'Não'}",
                    ),

                    const SizedBox(height: 10),

                    Text("Valor bruto: ${mostrarDinheiro(calcularValorBruto())}"),
                    Text(
                      "Desconto (${mostrarDescontoPercentual()}): "
                      "${mostrarDinheiro(calcularDesconto())}",
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Valor final: ${mostrarDinheiro(calcularValorFinal())}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: finalizarReserva,
                        child: const Text("Finalizar Reserva", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}