import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaguestats_mobile/core/models/leagues/league_list_response_dto.dart';
import 'package:leaguestats_mobile/core/models/leagues/league_team_response_dto.dart';
import 'package:leaguestats_mobile/core/services/league_service.dart';
import 'package:leaguestats_mobile/core/models/teams/team_list_response_dto.dart'
	as team_model;
import 'package:leaguestats_mobile/features/leagues/bloc/league_bloc.dart';
import 'package:leaguestats_mobile/features/teams/ui/team_deatil_page_view.dart';
import 'package:leaguestats_mobile/features/others/dynamic_network_image.dart';

class LeagueDetailPageView extends StatefulWidget {
	final int leagueId;
	final LeagueListResponseDto? league;

	const LeagueDetailPageView({
		super.key,
		required this.leagueId,
		this.league,
	});

	@override
	State<LeagueDetailPageView> createState() => _LeagueDetailPageViewState();
}

class _LeagueDetailPageViewState extends State<LeagueDetailPageView> {
	late final LeagueBloc _leagueInfoBloc;
	late final LeagueBloc _leagueTeamsBloc;

	@override
	void initState() {
		super.initState();
		_leagueInfoBloc = LeagueBloc(LeagueService())
			..add(LoadLeagueIdEvent(id: widget.leagueId));
		_leagueTeamsBloc = LeagueBloc(LeagueService())
			..add(LoadLeagueTeamsEvent(idTeam: widget.leagueId));
	}

	@override
	void dispose() {
		_leagueInfoBloc.close();
		_leagueTeamsBloc.close();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: const Color(0xFF0F0F11),
			appBar: AppBar(
				backgroundColor: const Color(0xFF0F0F11),
				elevation: 0,
				centerTitle: false,
				title: Text(
					'Detalle de liga',
					style: GoogleFonts.inter(
						color: Colors.white,
						fontWeight: FontWeight.w700,
					),
				),
			),
			body: MultiBlocProvider(
				providers: [
					BlocProvider.value(value: _leagueInfoBloc),
					BlocProvider.value(value: _leagueTeamsBloc),
				],
				child: Stack(
					children: [
						Positioned(
							top: -80,
							right: -60,
							child: Container(
								width: 220,
								height: 220,
								decoration: BoxDecoration(
									shape: BoxShape.circle,
									color: const Color(0xFF9333EA).withOpacity(0.10),
								),
							),
						),
						Positioned(
							bottom: -90,
							left: -70,
							child: Container(
								width: 220,
								height: 220,
								decoration: BoxDecoration(
									shape: BoxShape.circle,
									color: const Color(0xFF2563EB).withOpacity(0.08),
								),
							),
						),
						BlocBuilder<LeagueBloc, LeagueState>(
							bloc: _leagueInfoBloc,
							builder: (context, infoState) {
								final leagueFromState =
										infoState is SingleLeagueLoaded ? infoState.dto : null;
								final league = widget.league ?? leagueFromState;

								return ListView(
									padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
									children: [
										_buildHeaderCard(league),
										const SizedBox(height: 16),
										_buildSectionHeader(),
										const SizedBox(height: 12),
										BlocBuilder<LeagueBloc, LeagueState>(
											bloc: _leagueTeamsBloc,
											builder: (context, teamsState) {
												if (teamsState is LeagueLoading ||
														teamsState is LeagueInitial) {
													return const Center(
														child: Padding(
															padding: EdgeInsets.all(40.0),
															child: CircularProgressIndicator(
																color: Color(0xFF9333EA),
															),
														),
													);
												}

												if (teamsState is LeagueError) {
													return _buildErrorState();
												}

												if (teamsState is LeagueTeamsLoaded) {
													if (teamsState.dto.isEmpty) {
														return _buildEmptyState();
													}

													return GridView.builder(
														shrinkWrap: true,
														physics: const NeverScrollableScrollPhysics(),
														itemCount: teamsState.dto.length,
														gridDelegate:
																const SliverGridDelegateWithFixedCrossAxisCount(
																	crossAxisCount: 2,
																	crossAxisSpacing: 12,
																	mainAxisSpacing: 12,
																	childAspectRatio: 1.26,
																),
														itemBuilder: (context, index) {
															final team = teamsState.dto[index];
															return _buildTeamCard(team, index + 1);
														},
													);
												}

												return const SizedBox.shrink();
											},
										),
									],
								);
							},
						),
					],
				),
			),
		);
	}

	Widget _buildHeaderCard(LeagueListResponseDto? league) {
		return Container(
			decoration: BoxDecoration(
				gradient: const LinearGradient(
					colors: [Color(0xFF2A1F41), Color(0xFF1A1A21)],
					begin: Alignment.topLeft,
					end: Alignment.bottomRight,
				),
				borderRadius: BorderRadius.circular(20),
				border: Border.all(color: Colors.white.withOpacity(0.08)),
				boxShadow: [
					BoxShadow(
						color: const Color(0xFF000000).withOpacity(0.28),
						blurRadius: 16,
						offset: const Offset(0, 8),
					),
				],
			),
			padding: const EdgeInsets.all(20),
			child: Row(
				children: [
					Container(
						width: 90,
						height: 90,
						padding: const EdgeInsets.all(10),
						decoration: BoxDecoration(
							color: Colors.black.withOpacity(0.3),
							borderRadius: BorderRadius.circular(14),
						),
						child: DynamicNetworkImage(
							url: league?.logo ?? '',
							fit: BoxFit.contain,
						),
					),
					const SizedBox(width: 14),
					Expanded(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text(
									league?.name ?? 'Liga',
									maxLines: 2,
									overflow: TextOverflow.ellipsis,
									style: GoogleFonts.inter(
										color: Colors.white,
										fontSize: 24,
										fontWeight: FontWeight.bold,
									),
								),
								const SizedBox(height: 8),
								Row(
									children: [
										const Icon(
											Icons.public,
											size: 14,
											color: Color(0xFF9CA3AF),
										),
										const SizedBox(width: 6),
										Text(
											league?.country?.name ?? 'Sin país',
											style: GoogleFonts.inter(
												color: const Color(0xFF9CA3AF),
												fontSize: 13,
											),
										),
									],
								),
								const SizedBox(height: 10),
								Container(
									padding:
											const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
									decoration: BoxDecoration(
										color: const Color(0xFF9333EA).withOpacity(0.20),
										borderRadius: BorderRadius.circular(20),
										border: Border.all(
											color: const Color(0xFF9333EA).withOpacity(0.45),
										),
									),
									child: Text(
										'Competición oficial',
										style: GoogleFonts.inter(
											color: const Color(0xFFE9D5FF),
											fontSize: 11,
											fontWeight: FontWeight.w600,
										),
									),
								),
							],
						),
					),
				],
			),
		);
	}

	Widget _buildSectionHeader() {
		return Row(
			children: [
				Text(
					'Equipos',
					style: GoogleFonts.inter(
						color: Colors.white,
						fontSize: 20,
						fontWeight: FontWeight.w700,
					),
				),
				const SizedBox(width: 8),
				Container(
					width: 6,
					height: 6,
					decoration: const BoxDecoration(
						color: Color(0xFF9333EA),
						shape: BoxShape.circle,
					),
				),
				const Spacer(),
			],
		);
	}

	Widget _buildTeamCard(LeagueTeamResponseDto team, int rank) {
		return GestureDetector(
			onTap: () {
				Navigator.push(
					context,
					MaterialPageRoute(
						builder: (_) => TeamDetailPageView(team: _toTeamDetailModel(team)),
					),
				);
			},
			child: Container(
				decoration: BoxDecoration(
					gradient: const LinearGradient(
						colors: [Color(0xFF242834), Color(0xFF1C1F27)],
						begin: Alignment.topLeft,
						end: Alignment.bottomRight,
					),
					borderRadius: BorderRadius.circular(16),
					border: Border.all(color: Colors.white.withOpacity(0.06)),
				),
				padding: const EdgeInsets.all(12),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						Align(
							alignment: Alignment.topRight,
							child: Container(
								padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
								decoration: BoxDecoration(
									color: const Color(0xFF111827),
									borderRadius: BorderRadius.circular(10),
								),
								child: Text(
									'#$rank',
									style: GoogleFonts.inter(
										color: const Color(0xFF9CA3AF),
										fontSize: 10,
										fontWeight: FontWeight.w700,
									),
								),
							),
						),
						const SizedBox(height: 2),
						SizedBox(
							width: 44,
							height: 44,
							child: DynamicNetworkImage(
								url: team.logo ?? '',
								fit: BoxFit.contain,
							),
						),
						const SizedBox(height: 10),
						Text(
							team.name ?? 'Sin nombre',
							maxLines: 1,
							overflow: TextOverflow.ellipsis,
							textAlign: TextAlign.center,
							style: GoogleFonts.inter(
								color: Colors.white,
								fontWeight: FontWeight.w600,
							),
						),
						const SizedBox(height: 7),
						Text(
							'W ${team.wonMatches ?? 0}  •  L ${team.lostMatches ?? 0}',
							style: GoogleFonts.inter(
								color: const Color(0xFF9CA3AF),
								fontSize: 11,
							),
						),
					],
				),
			),
		);
	}

	Widget _buildErrorState() {
		return Container(
			padding: const EdgeInsets.all(20),
			decoration: BoxDecoration(
				color: const Color(0xFF1F1F23),
				borderRadius: BorderRadius.circular(16),
				border: Border.all(color: Colors.white.withOpacity(0.08)),
			),
			child: Center(
				child: Text(
					'Error cargando equipos',
					style: GoogleFonts.inter(
						color: const Color(0xFFD1D5DB),
					),
				),
			),
		);
	}

	team_model.TeamListResponseDto _toTeamDetailModel(LeagueTeamResponseDto team) {
		return team_model.TeamListResponseDto(
			id: team.id,
			name: team.name,
			logo: team.logo,
			countryId: team.countryId,
			lostMatches: team.lostMatches,
			wonMatches: team.wonMatches,
			leagueId: team.leagueId,
			teamWallpaper: team.teamWallpaper,
			createdAt: team.createdAt,
			updatedAt: team.updatedAt,
			league: team_model.League(
				id: widget.league?.id,
				name: widget.league?.name,
				logo: widget.league?.logo,
				countryId: widget.league?.country?.id,
			),
			country: team_model.Country(
				id: widget.league?.country?.id,
				name: widget.league?.country?.name,
				flag: widget.league?.country?.flag,
			),
		);
	}

	Widget _buildEmptyState() {
		return Container(
			padding: const EdgeInsets.all(20),
			decoration: BoxDecoration(
				color: const Color(0xFF1F1F23),
				borderRadius: BorderRadius.circular(16),
				border: Border.all(color: Colors.white.withOpacity(0.08)),
			),
			child: Text(
				'No hay equipos para esta liga.',
				style: GoogleFonts.inter(
					color: const Color(0xFF9CA3AF),
				),
			),
		);
	}
}
