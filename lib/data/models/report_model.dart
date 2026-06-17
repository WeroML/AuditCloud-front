import '../../core/utils/safe_parser.dart';

/// Modelo de reporte basado en reportes.json del backend
class ReportModel {
  final int? idReporte;
  final int idAuditoria;
  final String urlPdf; // Ruta/URL del archivo PDF
  final DateTime? fechaGeneracion;
  final String estado; // "BORRADOR", "COMPLETADO"

  ReportModel({
    this.idReporte,
    required this.idAuditoria,
    required this.urlPdf,
    this.fechaGeneracion,
    this.estado = 'BORRADOR',
  });

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_reporte': idReporte,
      'id_auditoria': idAuditoria,
      'url_pdf': urlPdf,
      'fecha_generacion': fechaGeneracion?.toIso8601String(),
      'estado': estado,
    };
  }

  /// Crea una instancia desde JSON del backend
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      idReporte: SafeParser.parseIntNullable(json, 'id_reporte'),
      idAuditoria: SafeParser.parseIntFromMultiplePaths(json, ['id_auditoria', 'auditoria.id_auditoria']),
      urlPdf: SafeParser.parseString(json, 'url_pdf'),
      fechaGeneracion: json['fecha_generacion'] != null
          ? DateTime.tryParse(json['fecha_generacion'].toString())
          : null,
      estado: SafeParser.parseString(json, 'estado', defaultValue: 'BORRADOR'),
    );
  }

  /// Crea una copia del modelo con campos actualizados
  ReportModel copyWith({
    int? idReporte,
    int? idAuditoria,
    String? urlPdf,
    DateTime? fechaGeneracion,
    String? estado,
  }) {
    return ReportModel(
      idReporte: idReporte ?? this.idReporte,
      idAuditoria: idAuditoria ?? this.idAuditoria,
      urlPdf: urlPdf ?? this.urlPdf,
      fechaGeneracion: fechaGeneracion ?? this.fechaGeneracion,
      estado: estado ?? this.estado,
    );
  }

  @override
  String toString() {
    return 'ReportModel(idReporte: $idReporte, idAuditoria: $idAuditoria, '
        'estado: $estado, urlPdf: $urlPdf)';
  }
}
