-- This file is part of MiXuP.
--
-- MiXuP is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, version 3 of the License.
--
-- MiXuP is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with MiXuP.  If not, see <http://www.gnu.org/licenses/>.
--
expanded class MIXUP_TRANSFORM_GRAMMAR_CONSTANTS

feature {} -- keywords
   kw_and: FIXED_STRING once then "KW:and".intern end
   kw_assign: FIXED_STRING once then "KW::=".intern end
   kw_case: FIXED_STRING once then "KW:case".intern end
   kw_close_bracket: FIXED_STRING once then "KW:]".intern end
   kw_close_parenthesis: FIXED_STRING once then "KW:)".intern end
   kw_coma: FIXED_STRING once then "KW:,".intern end
   kw_def: FIXED_STRING once then "KW:def".intern end
   kw_divide: FIXED_STRING once then "KW:/".intern end
   kw_dot: FIXED_STRING once then "KW:.".intern end
   kw_else: FIXED_STRING once then "KW:else".intern end
   kw_elseif: FIXED_STRING once then "KW:elseif".intern end
   kw_end: FIXED_STRING once then "KW:end".intern end
   kw_equal: FIXED_STRING once then "KW:=".intern end
   kw_from: FIXED_STRING once then "KW:from".intern end
   kw_greater_or_equal: FIXED_STRING once then "KW:>=".intern end
   kw_greater_than: FIXED_STRING once then "KW:>".intern end
   kw_identifier: FIXED_STRING once then "KW:identifier".intern end
   kw_if: FIXED_STRING once then "KW:if".intern end
   kw_init: FIXED_STRING once then "KW:init".intern end
   kw_input: FIXED_STRING once then "KW:input".intern end
   kw_less_or_equal: FIXED_STRING once then "KW:<=".intern end
   kw_less_than: FIXED_STRING once then "KW:<".intern end
   kw_loop: FIXED_STRING once then "KW:loop".intern end
   kw_minus: FIXED_STRING once then "KW:-".intern end
   kw_not_equal: FIXED_STRING once then "KW:/=".intern end
   kw_open_bracket: FIXED_STRING once then "KW:[".intern end
   kw_open_parenthesis: FIXED_STRING once then "KW:(".intern end
   kw_or: FIXED_STRING once then "KW:or".intern end
   kw_output: FIXED_STRING once then "KW:output".intern end
   kw_plus: FIXED_STRING once then "KW:+".intern end
   kw_power: FIXED_STRING once then "KW:^".intern end
   kw_skip: FIXED_STRING once then "KW:skip".intern end
   kw_then: FIXED_STRING once then "KW:then".intern end
   kw_times: FIXED_STRING once then "KW:*".intern end
   kw_transform: FIXED_STRING once then "KW:transform".intern end
   kw_until: FIXED_STRING once then "KW:until".intern end
   kw_value: FIXED_STRING once then "KW:value".intern end
   kw_when: FIXED_STRING once then "KW:when".intern end

   nt_addressable: FIXED_STRING once then "Addressable".intern end
   nt_aoccont: FIXED_STRING once then "AOCCont".intern end
   nt_argument: FIXED_STRING once then "Argument".intern end
   nt_assignorcall: FIXED_STRING once then "AssignOrCall".intern end
   nt_booleanand: FIXED_STRING once then "BooleanAnd".intern end
   nt_booleanandr: FIXED_STRING once then "BooleanAndR".intern end
   nt_booleancomp: FIXED_STRING once then "BooleanComp".intern end
   nt_booleancompr: FIXED_STRING once then "BooleanCompR".intern end
   nt_booleanor: FIXED_STRING once then "BooleanOr".intern end
   nt_booleanorr: FIXED_STRING once then "BooleanOrR".intern end
   nt_case: FIXED_STRING once then "Case".intern end
   nt_def: FIXED_STRING once then "Def".intern end
   nt_else: FIXED_STRING once then "Else".intern end
   nt_elseif: FIXED_STRING once then "ElseIf".intern end
   nt_expadd: FIXED_STRING once then "ExpAdd".intern end
   nt_expaddr: FIXED_STRING once then "ExpAddR".intern end
   nt_expatom: FIXED_STRING once then "ExpAtom".intern end
   nt_expatomr: FIXED_STRING once then "ExpAtomR".intern end
   nt_expcall: FIXED_STRING once then "ExpCall".intern end
   nt_expmult: FIXED_STRING once then "ExpMult".intern end
   nt_expmultr: FIXED_STRING once then "ExpMultR".intern end
   nt_exppow: FIXED_STRING once then "ExpPow".intern end
   nt_exppowr: FIXED_STRING once then "ExpPowR".intern end
   nt_expression: FIXED_STRING once then "Expression".intern end
   nt_if: FIXED_STRING once then "If".intern end
   nt_init: FIXED_STRING once then "Init".intern end
   nt_input: FIXED_STRING once then "Input".intern end
   nt_instruction: FIXED_STRING once then "Instruction".intern end
   nt_loop: FIXED_STRING once then "Loop".intern end
   nt_output: FIXED_STRING once then "Output".intern end
   nt_skip: FIXED_STRING once then "Skip".intern end
   nt_then: FIXED_STRING once then "Then".intern end
   nt_transformation: FIXED_STRING once then "Transformation".intern end
   nt_transform: FIXED_STRING once then "Transform".intern end
   nt_when: FIXED_STRING once then "When".intern end

   nt_list_argument: FIXED_STRING once then "Argument*".intern end
   nt_list_def: FIXED_STRING once then "Def*".intern end
   nt_list_elseif: FIXED_STRING once then "ElseIf*".intern end
   nt_list_expression: FIXED_STRING once then "Expression*".intern end
   nt_list_instruction: FIXED_STRING once then "Instruction*".intern end
   nt_list_when: FIXED_STRING once then "When*".intern end

end -- class MIXUP_TRANSFORM_GRAMMAR_CONSTANTS
